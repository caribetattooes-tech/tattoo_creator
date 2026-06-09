import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary colors - Instagram/TikTok style dark theme
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2D2D2D);
  static const Color cardBackground = Color(0xFF242424);

  // Accent colors
  static const Color primary = Color(0xFFE1306C); // Instagram pink
  static const Color primaryLight = Color(0xFFF7773F);
  static const Color secondary = Color(0xFF833AB4); // Instagram purple

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textHint = Color(0xFF666666);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}