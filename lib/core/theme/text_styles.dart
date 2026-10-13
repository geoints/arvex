import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static final TextTheme textTheme = TextTheme(
    displayLarge: const TextStyle(
      fontSize: 38,
      height: 1.1,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.2,
      color: AppColors.textPrimary,
    ),
    headlineLarge: const TextStyle(
      fontSize: 28,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.8,
      color: AppColors.textPrimary,
    ),
    headlineMedium: const TextStyle(
      fontSize: 22,
      height: 1.2,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: AppColors.textPrimary,
    ),
    titleLarge: const TextStyle(
      fontSize: 18,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: AppColors.textPrimary,
    ),
    titleMedium: const TextStyle(
      fontSize: 16,
      height: 1.3,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimary,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
    ),
    labelLarge: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.12,
      color: AppColors.textSecondary,
    ),
  );
}
