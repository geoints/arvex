import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/audio_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid || Platform.isIOS) {
    try {
      await AudioService.init(
        builder: () => arvexAudioHandler,
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.arvex.audio.channel',
          androidNotificationChannelName: 'Arvex playback',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
          androidShowNotificationBadge: true,
          notificationColor: Color(0xFF0E1117),
        ),
      );
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'Arvex audio service',
          context: ErrorDescription('AudioService init failed at app startup.'),
        ),
      );
    }
  }

  runApp(const App());
}
