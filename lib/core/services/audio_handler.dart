import 'package:audio_service/audio_service.dart';

import 'audio_player_service.dart';

/// Обёртка для audio_service и Android foreground playback.
class ArvexAudioHandler extends BaseAudioHandler {
  ArvexAudioHandler() : playerService = AudioPlayerService();

  final AudioPlayerService playerService;

  Future<void> updateNowPlaying({
    required String id,
    required String title,
    required String artist,
    String? album,
    String? artworkUrl,
  }) async {
    final item = MediaItem(
      id: id,
      title: title,
      artist: artist,
      album: album,
      artUri: artworkUrl != null ? Uri.tryParse(artworkUrl) : null,
    );

    mediaItem.add(item);
  }

  @override
  Future<void> play() async {
    await playerService.play();
    await AudioService.androidForceEnableMediaButtons();
    super.play();
  }

  @override
  Future<void> pause() async {
    await playerService.pause();
    super.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    await playerService.seek(position);
    super.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    await playerService.next();
    super.skipToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await playerService.previous();
    super.skipToPrevious();
  }

  @override
  Future<void> stop() async {
    await playerService.dispose();
    await super.stop();
  }
}

final arvexAudioHandler = ArvexAudioHandler();
