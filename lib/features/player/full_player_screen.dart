import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/player_providers.dart';
import '../../core/router/app_router.dart';

class FullPlayerScreen extends ConsumerWidget {
  const FullPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerControllerProvider);
    final track = playerState.currentTrack;
    final total = playerState.totalDuration;
    final progress = total.inMilliseconds <= 0
        ? 0.0
        : playerState.position.inMilliseconds / total.inMilliseconds;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.backgroundPrimary,
              ),
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: const ColoredBox(color: Color(0x33000000)),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColors.panel,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        track?.title.substring(0, 1).toUpperCase() ?? 'A',
                        style: const TextStyle(
                          fontSize: 88,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    track?.title ?? 'Не выбран',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    track?.artist ?? 'Выберите трек',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SliderTheme(
                    data: const SliderThemeData(
                      thumbColor: AppColors.textPrimary,
                      activeTrackColor: AppColors.textPrimary,
                      inactiveTrackColor: AppColors.divider,
                    ),
                    child: Slider(
                      value: progress.clamp(0.0, 1.0),
                      onChanged: (value) => ref
                          .read(playerControllerProvider.notifier)
                          .seek(value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(playerState.position),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        _formatDuration(total),
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => ref
                            .read(playerControllerProvider.notifier)
                            .toggleShuffle(),
                        icon: Icon(
                          Icons.shuffle_rounded,
                          color: playerState.shuffle
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          size: 26,
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(playerControllerProvider.notifier)
                            .previousTrack(),
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          color: AppColors.textPrimary,
                          size: 32,
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(playerControllerProvider.notifier)
                            .togglePlay(),
                        icon: Icon(
                          playerState.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: AppColors.textPrimary,
                          size: 48,
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(playerControllerProvider.notifier)
                            .nextTrack(),
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: AppColors.textPrimary,
                          size: 32,
                        ),
                      ),
                      IconButton(
                        onPressed: () => ref
                            .read(playerControllerProvider.notifier)
                            .toggleLoop(),
                        icon: Icon(
                          Icons.repeat_rounded,
                          color: playerState.loop
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _PlayerAction(
                        icon: Icons.queue_music_rounded,
                        onTap: () => context.push(AppRoutes.queue),
                      ),
                      _PlayerAction(
                        icon: Icons.equalizer_rounded,
                        onTap: () => context.push(AppRoutes.equalizer),
                      ),
                      _PlayerAction(
                        icon: Icons.timer_rounded,
                        onTap: () => context.push(AppRoutes.sleepTimer),
                      ),
                      _PlayerAction(
                        icon: Icons.edit_note_rounded,
                        onTap: () => context.push(AppRoutes.metadataEditor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _PlayerAction extends StatelessWidget {
  const _PlayerAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
