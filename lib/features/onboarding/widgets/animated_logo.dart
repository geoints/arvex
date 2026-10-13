import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -12 + (1 - animation.value) * 18),
          child: Transform.rotate(
            angle: (animation.value - 0.5) * 0.22,
            child: Transform.scale(
              scale: 0.82 + animation.value * 0.36,
              child: child,
            ),
          ),
        );
      },
      child: Container(
        width: 132,
        height: 132,
        decoration: BoxDecoration(
          color: AppColors.panel,
          borderRadius: BorderRadius.circular(36),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        child: const Center(
          child: Text(
            'A',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
