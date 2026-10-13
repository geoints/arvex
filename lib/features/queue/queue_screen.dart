import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/player_providers.dart';
import 'widgets/queue_item.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerControllerProvider);
    final queue = playerState.queue;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Очередь'),
        backgroundColor: AppColors.backgroundPrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ReorderableListView.builder(
            padding: const EdgeInsets.only(bottom: 20),
            itemCount: queue.length,
            onReorderItem: (oldIndex, newIndex) {
              ref
                  .read(playerControllerProvider.notifier)
                  .reorderQueue(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final track = queue[index];
              return Padding(
                key: ValueKey(track.id),
                padding: const EdgeInsets.only(bottom: 12),
                child: QueueItemWidget(
                  track: track,
                  isCurrent: index == playerState.currentIndex,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
