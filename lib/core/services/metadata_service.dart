import 'dart:io';

/// Базовый сервис метаданных для локальных файлов.
/// В дальнейшем можно заменить на более глубокую библиотеку тегов аудиофайлов.
class MetadataService {
  const MetadataService();

  Future<Map<String, String>> readMetadata(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return const {
        'title': 'Unknown title',
        'artist': 'Unknown artist',
        'album': 'Unknown album',
        'genre': 'Unknown',
      };
    }

    final filename = file.uri.pathSegments.isEmpty
        ? 'track'
        : file.uri.pathSegments.last.replaceAll(RegExp(r'\.[^.]+$'), '');

    final title = _cleanName(filename);
    final artist = 'Unknown artist';
    final album = 'Unknown album';
    final genre = 'Unknown';

    return {'title': title, 'artist': artist, 'album': album, 'genre': genre};
  }

  Future<void> writeMetadata(
    String filePath,
    Map<String, String> metadata,
  ) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return;
    }

    final sanitized = <String, String>{
      'title': metadata['title'] ?? _cleanName(file.uri.pathSegments.last),
      'artist': metadata['artist'] ?? 'Unknown artist',
      'album': metadata['album'] ?? 'Unknown album',
      'genre': metadata['genre'] ?? 'Unknown',
    };

    // Сохранение в локальный слой пока имитируется в памяти.
    // В реальном приложении здесь будет допись в тег аудиофайла.
    await Future<void>.delayed(const Duration(milliseconds: 50), () {
      final _ = sanitized;
    });
  }

  String _cleanName(String raw) {
    final sanitized = raw.replaceAll(RegExp(r'[_-]+'), ' ').trim();
    if (sanitized.isEmpty) {
      return 'Unknown title';
    }
    return sanitized;
  }
}
