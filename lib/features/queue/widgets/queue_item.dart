import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/track.dart';

class QueueItemWidget extends StatelessWidget {
  const QueueItemWidget({
    required this.track,
    required this.isCurrent,
    super.key,
  });

  final Track track;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.panelAlt : AppColors.panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  track.artist,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (isCurrent)
            const Icon(Icons.play_arrow_rounded, color: AppColors.textPrimary)
          else
            const Icon(
              Icons.drag_indicator_rounded,
              color: AppColors.textSecondary,
            ),
        ],
      ),
    );
  }
}
