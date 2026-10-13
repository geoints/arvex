import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: 'Manrope',
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      colorScheme: AppColors.colorScheme,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundPrimary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      dividerColor: AppColors.divider,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.backgroundSecondary,
        indicatorColor: AppColors.panelAlt,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.panelAlt,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
