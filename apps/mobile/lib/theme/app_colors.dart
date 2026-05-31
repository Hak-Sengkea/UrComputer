import 'package:flutter/material.dart';

/// TechForge Design System - Semantic Color Palette
/// Simplified naming for clearer implementation.

class AppColors {
  // Brand Colors
  static const Color brandBlue = Color(0xFF7CB9FF);
  static const Color brandBlueDark = Color(0xFF003258);
  static const Color brandBlueContainer = Color(0xFF00497D);
  static const Color onBrandBlueContainer = Color(0xFFD1E4FF);

  // Surface & Neutral Colors
  static const Color background = Color(0xFF1A1C1E);
  static const Color surface = Color(0xFF1A1C1E);
  static const Color surfaceVariant = Color(0xFF43474E);
  static const Color onSurface = Color(0xFFE2E2E6);
  static const Color onSurfaceMuted = Color(0xFFC3C7CF);
  static const Color outline = Color(0xFF8D9199);

  // Functional Colors
  static const Color error = Color(0xFFFFB4AB);
  static const Color success = Color(0xFFB4FFAB); // Suggested addition for common UI needs
  static const Color warning = Color(0xFFFFDAB4); // Suggested addition for common UI needs

  // MD3 Mapping (for reference or use in Theme)
  static const Color primary = brandBlue;
  static const Color onPrimary = brandBlueDark;
  static const Color secondary = Color(0xFFBBC7DB);
}
