import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class WaveAnimation extends StatelessWidget {
  const WaveAnimation({required this.animation, super.key});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _WavePainter(animation.value),
          size: const Size(280, 120),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    const amplitude = 18.0;
    const phase = 18.0;

    for (double x = 0; x <= size.width; x += 2) {
      final y =
          size.height * 0.5 +
          sin((x / 24) + (progress * 16)) * amplitude +
          cos((x / 32) + phase) * 8;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
