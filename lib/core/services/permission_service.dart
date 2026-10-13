import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/// Запрос и проверка прав доступа для чтения музыки и уведомлений.
class PermissionService {
  const PermissionService();

  Future<bool> requestAudioPermissions() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final audioStatus = await Permission.audio.request();
    final notificationStatus = await Permission.notification.request();

    if (audioStatus.isGranted && notificationStatus.isGranted) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    return audioStatus.isGranted &&
        (notificationStatus.isGranted || notificationStatus.isDenied) &&
        storageStatus.isGranted;
  }
}
