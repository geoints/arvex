import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/player_providers.dart';
import '../../core/router/app_router.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(playerControllerProvider);
    final track = state.currentTrack;

    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.panel,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                track?.title.substring(0, 1).toUpperCase() ?? 'A',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (track != null) {
                  context.push(AppRoutes.player);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    track?.title ?? 'Не выбран',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    track?.artist ?? 'Выберите трек',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () =>
                ref.read(playerControllerProvider.notifier).previousTrack(),
            icon: const Icon(
              Icons.skip_previous_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () =>
                ref.read(playerControllerProvider.notifier).togglePlay(),
            icon: Icon(
              state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: AppColors.textPrimary,
              size: 28,
            ),
          ),
          IconButton(
            onPressed: () =>
                ref.read(playerControllerProvider.notifier).nextTrack(),
            icon: const Icon(
              Icons.skip_next_rounded,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
