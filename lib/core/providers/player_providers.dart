import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart' as ja;

import '../../models/track.dart';
import '../services/audio_handler.dart';
import '../services/audio_player_service.dart';
import '../services/database_service.dart';

final libraryTracksProvider = NotifierProvider<LibraryController, List<Track>>(
  () => LibraryController(),
);

final playerControllerProvider =
    NotifierProvider<PlayerController, PlayerState>(() => PlayerController());

class PlayerState {
  const PlayerState({
    required this.queue,
    required this.currentIndex,
    required this.isPlaying,
    required this.position,
    required this.totalDuration,
    required this.shuffle,
    required this.loop,
  });

  final List<Track> queue;
  final int currentIndex;
  final bool isPlaying;
  final Duration position;
  final Duration totalDuration;
  final bool shuffle;
  final bool loop;

  Track? get currentTrack =>
      queue.isEmpty || currentIndex < 0 || currentIndex >= queue.length
      ? null
      : queue[currentIndex];

  PlayerState copyWith({
    List<Track>? queue,
    int? currentIndex,
    bool? isPlaying,
    Duration? position,
    Duration? totalDuration,
    bool? shuffle,
    bool? loop,
  }) {
    return PlayerState(
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      totalDuration: totalDuration ?? this.totalDuration,
      shuffle: shuffle ?? this.shuffle,
      loop: loop ?? this.loop,
    );
  }
}

class LibraryController extends Notifier<List<Track>> {
  LibraryController() : _database = DatabaseService();

  final DatabaseService _database;

  @override
  List<Track> build() {
    Future.microtask(() => load());
    return const <Track>[];
  }

  Future<void> load() async {
    await _database.initialize();

    final savedTracks = await _database.getTracks();
    if (savedTracks.isNotEmpty) {
      state = savedTracks;
      return;
    }

    state = _demoTracks;
  }

  Future<void> addTracks(List<Track> tracks) async {
    final merged = <Track>[...state];
    for (final track in tracks) {
      final exists = merged.any((item) => item.isSameTrack(track));
      if (!exists) {
        merged.add(track);
      }
      await _database.saveTrack(track);
    }
    state = merged;
  }
}

class PlayerController extends Notifier<PlayerState> {
  PlayerController() : _service = AudioPlayerService();

  final AudioPlayerService _service;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<ja.PlayerState>? _playerStateSub;

  @override
  PlayerState build() {
    _positionSub = _service.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    _durationSub = _service.durationStream.listen((duration) {
      if (duration != null && duration > Duration.zero) {
        state = state.copyWith(totalDuration: duration);
      }
    });

    _playerStateSub = _service.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      state = state.copyWith(isPlaying: isPlaying);

      if (playerState.processingState == ja.ProcessingState.completed &&
          state.queue.isNotEmpty) {
        nextTrack();
      }
    });

    ref.onDispose(() async {
      await _positionSub?.cancel();
      await _durationSub?.cancel();
      await _playerStateSub?.cancel();
      await _service.dispose();
    });

    return const PlayerState(
      queue: _demoTracks,
      currentIndex: 0,
      isPlaying: false,
      position: Duration.zero,
      totalDuration: Duration.zero,
      shuffle: false,
      loop: false,
    );
  }

  Future<void> _syncQueue() async {
    final paths = state.queue
        .map((track) => track.path ?? '')
        .where((path) => path.trim().isNotEmpty)
        .toList();

    if (paths.isEmpty) {
      return;
    }

    await _service.setQueue(paths, initialIndex: state.currentIndex);
  }

  Future<void> setQueueFromTracks(
    List<Track> tracks, {
    int initialIndex = 0,
  }) async {
    if (tracks.isEmpty) {
      state = state.copyWith(queue: const <Track>[], currentIndex: 0);
      return;
    }

    final safeIndex = initialIndex.clamp(0, tracks.length - 1);
    final selected = tracks[safeIndex];

    state = state.copyWith(
      queue: tracks,
      currentIndex: safeIndex,
      position: Duration.zero,
      totalDuration: selected.duration,
    );

    final paths = tracks
        .map((track) => track.path ?? '')
        .where((path) => path.trim().isNotEmpty)
        .toList();
    if (paths.isNotEmpty) {
      await _service.setQueue(paths, initialIndex: safeIndex);
    }
  }

  Future<void> playTrack(Track track, [List<Track>? trackList]) async {
    final queue = (trackList ?? [...state.queue]).isEmpty
        ? <Track>[track]
        : [...(trackList ?? state.queue)];

    final existingIndex = queue.indexWhere((item) => item.isSameTrack(track));
    final index = existingIndex >= 0 ? existingIndex : queue.length;
    if (existingIndex < 0) {
      queue.add(track);
    }

    final selected = queue[index];
    state = state.copyWith(
      queue: queue,
      currentIndex: index,
      position: Duration.zero,
      totalDuration: selected.duration,
      isPlaying: true,
    );

    if (selected.path != null && selected.path!.isNotEmpty) {
      await _publishNowPlaying(selected);
      await _service.setFileSource(selected.path!);
      await _service.play();
    }
  }

  Future<void> togglePlay() async {
    if (state.currentTrack == null) {
      return;
    }

    if (state.isPlaying) {
      await _service.pause();
    } else {
      await _service.play();
    }

    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  Future<void> nextTrack() async {
    if (state.queue.isEmpty) {
      return;
    }

    final nextIndex = (state.currentIndex + 1) % state.queue.length;
    final nextTrack = state.queue[nextIndex];
    await playTrack(nextTrack, state.queue);
  }

  Future<void> previousTrack() async {
    if (state.queue.isEmpty) {
      return;
    }

    final previousIndex =
        (state.currentIndex - 1 + state.queue.length) % state.queue.length;
    final previousTrack = state.queue[previousIndex];
    await playTrack(previousTrack, state.queue);
  }

  Future<void> seek(double value) async {
    final totalMs = state.totalDuration.inMilliseconds;
    if (totalMs <= 0) {
      return;
    }

    final millis = (totalMs * value).round();
    final position = Duration(milliseconds: millis);
    await _service.seek(position);
    state = state.copyWith(position: position);
  }

  Future<void> reorderQueue(int oldIndex, int newIndex) async {
    if (oldIndex < 0 ||
        oldIndex >= state.queue.length ||
        newIndex < 0 ||
        newIndex >= state.queue.length) {
      return;
    }

    final queue = [...state.queue];
    final item = queue.removeAt(oldIndex);
    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    queue.insert(adjustedIndex, item);

    final currentIndex = queue.indexWhere(
      (track) => track.id == state.currentTrack?.id,
    );

    state = state.copyWith(queue: queue, currentIndex: currentIndex);
    await _syncQueue();
  }

  Future<void> toggleShuffle() async {
    final enabled = !state.shuffle;
    await _service.setShuffle(enabled);
    state = state.copyWith(shuffle: enabled);
  }

  Future<void> toggleLoop() async {
    final enabled = !state.loop;
    final mode = enabled ? ja.LoopMode.one : ja.LoopMode.off;
    await _service.setLoopMode(mode);
    state = state.copyWith(loop: enabled);
  }

  Future<void> _publishNowPlaying(Track track) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }

    try {
      arvexAudioHandler.mediaItem.add(
        MediaItem(
          id: track.id,
          title: track.title,
          artist: track.artist,
          album: track.album,
          duration: track.duration,
        ),
      );
      await AudioService.androidForceEnableMediaButtons();
    } catch (_) {}
  }
}

const List<Track> _demoTracks = [
  Track(
    id: '1',
    title: 'Midnight Echo',
    artist: 'Aster Vale',
    album: 'Night Signals',
    genre: 'Electronic',
    year: 2024,
    trackNumber: 1,
    duration: Duration(minutes: 0, seconds: 17),
    dateAdded: null,
    fileHash: 'hash1',
    path: 'assets/audio/midnight_echo.wav',
  ),
  Track(
    id: '2',
    title: 'Velvet Static',
    artist: 'Mira Sloane',
    album: 'Glass City',
    genre: 'Ambient',
    year: 2023,
    trackNumber: 2,
    duration: Duration(minutes: 0, seconds: 16),
    dateAdded: null,
    fileHash: 'hash2',
    path: 'assets/audio/velvet_static.wav',
  ),
  Track(
    id: '3',
    title: 'Black Thread',
    artist: 'Night Parade',
    album: 'Wired Bloom',
    genre: 'Indie',
    year: 2025,
    trackNumber: 3,
    duration: Duration(minutes: 0, seconds: 18),
    dateAdded: null,
    fileHash: 'hash3',
    path: 'assets/audio/black_thread.wav',
  ),
];
