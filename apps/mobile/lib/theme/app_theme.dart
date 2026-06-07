import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_style.dart';
import 'theme_extensions.dart';

class AppTheme {
  static const Color primary = Color(0xFF00D1FF);
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonPurple = Color(0xFFB44CFF);
  static const Color neonPink = Color(0xFFFF4D8C);
  static const Color darkBg = Color(0xFF0A0A0A);
  static const Color cardBg = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF888888);

  static final _sharedSizes = const AppSizesExtension(
    space4: 4.0,
    space8: 8.0,
    space12: 12.0,
    space16: 16.0,
    space24: 24.0,
    space32: 32.0,
    space48: 48.0,
    radiusSmall: 8.0,
    radiusMedium: 12.0,
    radiusLarge: 16.0,
    radiusPill: 100.0,
    edgeMarginMobile: 16.0,
    edgeMarginDesktop: 32.0,
    appBarHeight: 64.0,
    bottomNavHeight: 80.0,
  );

  static final _sharedColors = const AppColorsExtension(
    neonCyan: neonCyan,
    neonPurple: neonPurple,
    neonPink: neonPink,
    darkBg: darkBg,
    cardBg: cardBg,
    textSecondary: textSecondary,
    success: AppColors.success,
    warning: AppColors.warning,
    primaryGradient: LinearGradient(
      colors: [neonCyan, neonPurple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    backgroundGradient: LinearGradient(
      colors: [AppColors.surface, Color(0xFF10151C), AppColors.surfaceVariant],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      extensions: <ThemeExtension<dynamic>>[
        _sharedColors,
        _sharedSizes,
      ],
      textTheme: const TextTheme(
        displayLarge: AppTextStyle.displayLarge,
        displayMedium: AppTextStyle.displayMedium,
        displaySmall: AppTextStyle.displaySmall,
        headlineLarge: AppTextStyle.headlineLarge,
        headlineMedium: AppTextStyle.headlineMedium,
        headlineSmall: AppTextStyle.headlineSmall,
        titleLarge: AppTextStyle.titleLarge,
        titleMedium: AppTextStyle.titleMedium,
        titleSmall: AppTextStyle.titleSmall,
        bodyLarge: AppTextStyle.bodyLarge,
        bodyMedium: AppTextStyle.bodyMedium,
        bodySmall: AppTextStyle.bodySmall,
        labelLarge: AppTextStyle.labelLarge,
        labelMedium: AppTextStyle.labelMedium,
        labelSmall: AppTextStyle.labelSmall,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceVariant,
        outline: AppColors.outline,
        error: AppColors.error,
      ),
      extensions: <ThemeExtension<dynamic>>[
        _sharedColors,
        _sharedSizes,
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyle.displayLarge,
        displayMedium: AppTextStyle.displayMedium,
        displaySmall: AppTextStyle.displaySmall,
        headlineLarge: AppTextStyle.headlineLarge,
        headlineMedium: AppTextStyle.headlineMedium,
        headlineSmall: AppTextStyle.headlineSmall,
        titleLarge: AppTextStyle.titleLarge,
        titleMedium: AppTextStyle.titleMedium,
        titleSmall: AppTextStyle.titleSmall,
        bodyLarge: AppTextStyle.bodyLarge,
        bodyMedium: AppTextStyle.bodyMedium,
        bodySmall: AppTextStyle.bodySmall,
        labelLarge: AppTextStyle.labelLarge,
        labelMedium: AppTextStyle.labelMedium,
        labelSmall: AppTextStyle.labelSmall,
      ),
    );
  }
}