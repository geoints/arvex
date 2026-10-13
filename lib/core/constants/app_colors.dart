import 'package:flutter/material.dart';

/// Тёмная палитра Arvex: минимализм, мрак и премиум-материал.
class AppColors {
  const AppColors._();

  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF0A0A0A);
  static const Color panel = Color(0xFF1A1A1A);
  static const Color panelAlt = Color(0xFF222222);
  static const Color divider = Color(0xFF2A2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color accent = Color(0xFFFFFFFF);
  static const Color glow = Color(0xFF4A4A4A);

  static const ColorScheme colorScheme = ColorScheme.dark(
    primary: accent,
    secondary: accent,
    surface: panel,
    onPrimary: backgroundPrimary,
    onSecondary: backgroundPrimary,
    onSurface: textPrimary,
    error: Color(0xFFB00020),
    onError: textPrimary,
  );
}
