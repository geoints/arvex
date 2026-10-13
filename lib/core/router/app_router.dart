import 'package:go_router/go_router.dart';

import '../../features/equalizer/equalizer_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/import/import_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/metadata_editor/metadata_editor_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/player/full_player_screen.dart';
import '../../features/playlists/playlists_screen.dart';
import '../../features/queue/queue_screen.dart';
import '../../features/sleep_timer/sleep_timer_screen.dart';
import '../../features/splash/splash_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const library = '/library';
  static const playlists = '/playlists';
  static const player = '/player';
  static const queue = '/queue';
  static const import = '/import';
  static const equalizer = '/equalizer';
  static const sleepTimer = '/sleep-timer';
  static const metadataEditor = '/metadata-editor';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.library,
        name: 'library',
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: AppRoutes.playlists,
        name: 'playlists',
        builder: (context, state) => const PlaylistsScreen(),
      ),
      GoRoute(
        path: AppRoutes.player,
        name: 'player',
        builder: (context, state) => const FullPlayerScreen(),
      ),
      GoRoute(
        path: AppRoutes.queue,
        name: 'queue',
        builder: (context, state) => const QueueScreen(),
      ),
      GoRoute(
        path: AppRoutes.import,
        name: 'import',
        builder: (context, state) => const ImportScreen(),
      ),
      GoRoute(
        path: AppRoutes.equalizer,
        name: 'equalizer',
        builder: (context, state) => const EqualizerScreen(),
      ),
      GoRoute(
        path: AppRoutes.sleepTimer,
        name: 'sleepTimer',
        builder: (context, state) => const SleepTimerScreen(),
      ),
      GoRoute(
        path: AppRoutes.metadataEditor,
        name: 'metadataEditor',
        builder: (context, state) => const MetadataEditorScreen(),
      ),
    ],
  );
}
