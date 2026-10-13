import 'dart:io';

import 'package:just_audio/just_audio.dart';

/// Shared audio engine used by the UI, background service and Android media controls.
class AudioPlayerService {
  AudioPlayerService._() : _player = AudioPlayer();

  static final AudioPlayerService instance = AudioPlayerService._();

  final AudioPlayer _player;

  AudioPlayer get player => _player;
  bool get isPlaying => _player.playing;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> setSource(String url) async {
    await _player.setUrl(url);
  }

  Future<void> setFileSource(String path) async {
    if (path.trim().isEmpty) {
      return;
    }

    if (path.startsWith('assets/')) {
      await _player.setAudioSource(AudioSource.asset(path));
      return;
    }

    if (!File(path).existsSync()) {
      return;
    }

    await _player.setFilePath(path);
  }

  Future<void> setQueue(List<String> paths, {int initialIndex = 0}) async {
    final sources = <AudioSource>[];

    for (final path in paths) {
      if (path.trim().isEmpty) {
        continue;
      }

      if (path.startsWith('assets/')) {
        sources.add(AudioSource.asset(path));
      } else if (File(path).existsSync()) {
        sources.add(AudioSource.uri(Uri.file(path)));
      }
    }

    if (sources.isEmpty) {
      return;
    }

    await _player.setAudioSources(
      sources,
      initialIndex: initialIndex.clamp(0, sources.length - 1),
    );
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> next() async {
    await _player.seekToNext();
  }

  Future<void> previous() async {
    await _player.seekToPrevious();
  }

  Future<void> setShuffle(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);
  }

  Future<void> setLoopMode(LoopMode mode) async {
    await _player.setLoopMode(mode);
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
