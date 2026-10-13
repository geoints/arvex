import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

/// Импорт локальных аудиофайлов и дедупликация по хешу и метаданным.
class ImportService {
  const ImportService();

  static const Set<String> supportedExtensions = {
    'mp3',
    'aac',
    'm4a',
    'flac',
    'wav',
    'ogg',
    'opus',
    'wma',
    'aiff',
    'alac',
    'ape',
  };

  bool isSupportedAudioPath(String path) {
    final extension = p.extension(path).replaceFirst('.', '').toLowerCase();
    return supportedExtensions.contains(extension);
  }

  Future<bool> validateAudioFilePath(String path) async {
    final normalizedPath = path.trim();
    if (normalizedPath.isEmpty || !isSupportedAudioPath(normalizedPath)) {
      return false;
    }

    final file = File(normalizedPath);
    if (!await file.exists()) {
      return false;
    }

    final size = await file.length();
    return size > 0;
  }

  Future<List<String>> importFiles(List<String> paths) async {
    final result = <String>[];
    final seenHashes = <String>{};
    final seenCompositeKeys = <String>{};

    for (final path in paths) {
      final normalizedPath = path.trim();
      if (normalizedPath.isEmpty ||
          !await validateAudioFilePath(normalizedPath)) {
        continue;
      }

      final file = File(normalizedPath);
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        continue;
      }

      final hash = sha256.convert(bytes).toString();
      final title = p.basenameWithoutExtension(normalizedPath);
      final compositeKey = '$title|${hash.substring(0, 12)}';

      if (seenHashes.contains(hash) ||
          seenCompositeKeys.contains(compositeKey)) {
        continue;
      }

      seenHashes.add(hash);
      seenCompositeKeys.add(compositeKey);
      result.add(normalizedPath);
    }

    return result;
  }

  Future<List<String>> pickAudioFiles() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: supportedExtensions.toList(),
    );

    final paths = files
        .map((file) => file.path)
        .whereType<String>()
        .where((path) => path.trim().isNotEmpty)
        .toList();

    return importFiles(paths);
  }

  Future<List<String>> scanDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return const <String>[];
    }

    final files = <String>[];
    final entities = directory.listSync(recursive: true, followLinks: false);

    for (final entity in entities) {
      if (entity is! File) {
        continue;
      }

      final path = entity.path;
      if (isSupportedAudioPath(path)) {
        files.add(path);
      }
    }

    return importFiles(files);
  }
}
