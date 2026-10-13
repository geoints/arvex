import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../models/playlist.dart';
import '../../models/track.dart';

/// Стабильное файловое хранилище для локальной библиотеки и плейлистов.
class DatabaseService {
  DatabaseService();

  static const String _tracksFileName = 'tracks.json';
  static const String _playlistsFileName = 'playlists.json';

  Future<Directory> _appDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  }

  Future<File> _tracksFile() async {
    final dir = await _appDirectory();
    return File('${dir.path}/$_tracksFileName');
  }

  Future<File> _playlistsFile() async {
    final dir = await _appDirectory();
    return File('${dir.path}/$_playlistsFileName');
  }

  Future<void> initialize() async {
    final trackFile = await _tracksFile();
    final playlistFile = await _playlistsFile();

    if (!await trackFile.exists()) {
      await trackFile.create(recursive: true);
      await trackFile.writeAsString('[]');
    }

    if (!await playlistFile.exists()) {
      await playlistFile.create(recursive: true);
      await playlistFile.writeAsString('[]');
    }
  }

  Future<void> saveTrack(Track track) async {
    final current = await getTracks();
    final index = current.indexWhere((item) => item.id == track.id);
    final updated = List<Track>.from(current);
    if (index >= 0) {
      updated[index] = track;
    } else {
      updated.add(track);
    }

    final file = await _tracksFile();
    await file.writeAsString(
      jsonEncode(updated.map((item) => item.toJson()).toList()),
    );
  }

  Future<List<Track>> getTracks() async {
    final file = await _tracksFile();
    if (!await file.exists()) {
      await initialize();
      return const <Track>[];
    }

    final raw = await file.readAsString();
    if (raw.trim().isEmpty) {
      return const <Track>[];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Track.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> savePlaylist(Playlist playlist) async {
    final current = await getPlaylists();
    final index = current.indexWhere((item) => item.id == playlist.id);
    final updated = List<Playlist>.from(current);
    if (index >= 0) {
      updated[index] = playlist;
    } else {
      updated.add(playlist);
    }

    final file = await _playlistsFile();
    await file.writeAsString(
      jsonEncode(updated.map((item) => item.toJson()).toList()),
    );
  }

  Future<List<Playlist>> getPlaylists() async {
    final file = await _playlistsFile();
    if (!await file.exists()) {
      await initialize();
      return const <Playlist>[];
    }

    final raw = await file.readAsString();
    if (raw.trim().isEmpty) {
      return const <Playlist>[];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Playlist.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteTrack(String id) async {
    final tracks = await getTracks();
    final filtered = tracks.where((track) => track.id != id).toList();
    final file = await _tracksFile();
    await file.writeAsString(
      jsonEncode(filtered.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> deletePlaylist(String id) async {
    final playlists = await getPlaylists();
    final filtered = playlists.where((playlist) => playlist.id != id).toList();
    final file = await _playlistsFile();
    await file.writeAsString(
      jsonEncode(filtered.map((item) => item.toJson()).toList()),
    );
  }
}
