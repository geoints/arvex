import 'dart:convert';

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.year,
    required this.trackNumber,
    required this.duration,
    required this.dateAdded,
    required this.fileHash,
    this.path,
  });

  final String id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final int year;
  final int trackNumber;
  final Duration duration;
  final DateTime? dateAdded;
  final String fileHash;
  final String? path;

  String get coverAsset => 'assets/images/cover_default.png';

  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? genre,
    int? year,
    int? trackNumber,
    Duration? duration,
    DateTime? dateAdded,
    String? fileHash,
    String? path,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      trackNumber: trackNumber ?? this.trackNumber,
      duration: duration ?? this.duration,
      dateAdded: dateAdded ?? this.dateAdded,
      fileHash: fileHash ?? this.fileHash,
      path: path ?? this.path,
    );
  }

  bool matchesQuery(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return true;
    }

    final fullText = [
      title,
      artist,
      album,
      genre,
    ].map((value) => value.toLowerCase()).join(' ');
    return fullText.contains(normalized.toLowerCase());
  }

  bool isSameTrack(Track other) {
    if (id == other.id) {
      return true;
    }
    if (path != null && other.path != null && path == other.path) {
      return true;
    }
    if (fileHash.isNotEmpty && fileHash == other.fileHash) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'genre': genre,
      'year': year,
      'trackNumber': trackNumber,
      'durationMs': duration.inMilliseconds,
      'dateAdded': dateAdded?.toUtc().toIso8601String(),
      'fileHash': fileHash,
      'path': path,
    };
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id:
          json['id'] as String? ??
          base64.encode(
            utf8.encode(
              json['path'] ?? json['title'] ?? DateTime.now().toIso8601String(),
            ),
          ),
      title: json['title'] as String? ?? 'Unknown title',
      artist: json['artist'] as String? ?? 'Unknown artist',
      album: json['album'] as String? ?? 'Unknown album',
      genre: json['genre'] as String? ?? 'Unknown',
      year: json['year'] as int? ?? 0,
      trackNumber: json['trackNumber'] as int? ?? 0,
      duration: Duration(milliseconds: json['durationMs'] as int? ?? 0),
      dateAdded: json['dateAdded'] == null
          ? null
          : DateTime.tryParse(json['dateAdded'] as String? ?? ''),
      fileHash: json['fileHash'] as String? ?? '',
      path: json['path'] as String?,
    );
  }
}
