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
    final storageStatus = await Permission.storage.request();

    final hasAudioAccess = audioStatus.isGranted || audioStatus.isLimited;
    final hasNotificationAccess = notificationStatus.isGranted;
    final hasStorageAccess = storageStatus.isGranted || storageStatus.isLimited;

    return hasAudioAccess && hasNotificationAccess && hasStorageAccess;
  }
}
