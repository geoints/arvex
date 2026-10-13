class Playlist {
  const Playlist({
    required this.id,
    required this.name,
    required this.trackIds,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final List<String> trackIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Playlist copyWith({
    String? id,
    String? name,
    List<String>? trackIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      trackIds: trackIds ?? this.trackIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Playlist addTrack(String trackId) {
    final normalized = trackId.trim();
    if (normalized.isEmpty || trackIds.contains(normalized)) {
      return this;
    }

    return copyWith(
      trackIds: [...trackIds, normalized],
      updatedAt: DateTime.now(),
    );
  }

  Playlist removeTrack(String trackId) {
    final normalized = trackId.trim();
    if (normalized.isEmpty) {
      return this;
    }

    return copyWith(
      trackIds: trackIds.where((id) => id != normalized).toList(),
      updatedAt: DateTime.now(),
    );
  }

  Playlist rename(String newName) {
    final normalized = newName.trim();
    if (normalized.isEmpty) {
      return this;
    }

    return copyWith(name: normalized, updatedAt: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'trackIds': trackIds,
      'createdAt': createdAt?.toUtc().toIso8601String(),
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
    };
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'New Playlist',
      trackIds: (json['trackIds'] as List<dynamic>? ?? const <dynamic>[])
          .map((e) => e.toString())
          .toList(),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
