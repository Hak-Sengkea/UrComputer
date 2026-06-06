import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Extension to hold custom colors and gradients that do not fit in the standard ColorScheme
@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color neonCyan;
  final Color neonPurple;
  final Color neonPink;
  final Color darkBg;
  final Color cardBg;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final LinearGradient primaryGradient;
  final LinearGradient backgroundGradient;

  const AppColorsExtension({
    required this.neonCyan,
    required this.neonPurple,
    required this.neonPink,
    required this.darkBg,
    required this.cardBg,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.primaryGradient,
    required this.backgroundGradient,
  });

  @override
  AppColorsExtension copyWith({
    Color? neonCyan,
    Color? neonPurple,
    Color? neonPink,
    Color? darkBg,
    Color? cardBg,
    Color? textSecondary,
    Color? success,
    Color? warning,
    LinearGradient? primaryGradient,
    LinearGradient? backgroundGradient,
  }) {
    return AppColorsExtension(
      neonCyan: neonCyan ?? this.neonCyan,
      neonPurple: neonPurple ?? this.neonPurple,
      neonPink: neonPink ?? this.neonPink,
      darkBg: darkBg ?? this.darkBg,
      cardBg: cardBg ?? this.cardBg,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      neonCyan: Color.lerp(neonCyan, other.neonCyan, t)!,
      neonPurple: Color.lerp(neonPurple, other.neonPurple, t)!,
      neonPink: Color.lerp(neonPink, other.neonPink, t)!,
      darkBg: Color.lerp(darkBg, other.darkBg, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      backgroundGradient: LinearGradient.lerp(backgroundGradient, other.backgroundGradient, t)!,
    );
  }
}

/// Extension to hold layout spacing, sizing, and corner radii centrally
@immutable
class AppSizesExtension extends ThemeExtension<AppSizesExtension> {
  final double space4;
  final double space8;
  final double space12;
  final double space16;
  final double space24;
  final double space32;
  final double space48;

  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;
  final double radiusPill;

  final double edgeMarginMobile;
  final double edgeMarginDesktop;

  final double appBarHeight;
  final double bottomNavHeight;

  const AppSizesExtension({
    required this.space4,
    required this.space8,
    required this.space12,
    required this.space16,
    required this.space24,
    required this.space32,
    required this.space48,
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.radiusPill,
    required this.edgeMarginMobile,
    required this.edgeMarginDesktop,
    required this.appBarHeight,
    required this.bottomNavHeight,
  });

  @override
  AppSizesExtension copyWith({
    double? space4,
    double? space8,
    double? space12,
    double? space16,
    double? space24,
    double? space32,
    double? space48,
    double? radiusSmall,
    double? radiusMedium,
    double? radiusLarge,
    double? radiusPill,
    double? edgeMarginMobile,
    double? edgeMarginDesktop,
    double? appBarHeight,
    double? bottomNavHeight,
  }) {
    return AppSizesExtension(
      space4: space4 ?? this.space4,
      space8: space8 ?? this.space8,
      space12: space12 ?? this.space12,
      space16: space16 ?? this.space16,
      space24: space24 ?? this.space24,
      space32: space32 ?? this.space32,
      space48: space48 ?? this.space48,
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      radiusPill: radiusPill ?? this.radiusPill,
      edgeMarginMobile: edgeMarginMobile ?? this.edgeMarginMobile,
      edgeMarginDesktop: edgeMarginDesktop ?? this.edgeMarginDesktop,
      appBarHeight: appBarHeight ?? this.appBarHeight,
      bottomNavHeight: bottomNavHeight ?? this.bottomNavHeight,
    );
  }

  @override
  AppSizesExtension lerp(ThemeExtension<AppSizesExtension>? other, double t) {
    if (other is! AppSizesExtension) return this;
    return AppSizesExtension(
      space4: lerpDouble(space4, other.space4, t)!,
      space8: lerpDouble(space8, other.space8, t)!,
      space12: lerpDouble(space12, other.space12, t)!,
      space16: lerpDouble(space16, other.space16, t)!,
      space24: lerpDouble(space24, other.space24, t)!,
      space32: lerpDouble(space32, other.space32, t)!,
      space48: lerpDouble(space48, other.space48, t)!,
      radiusSmall: lerpDouble(radiusSmall, other.radiusSmall, t)!,
      radiusMedium: lerpDouble(radiusMedium, other.radiusMedium, t)!,
      radiusLarge: lerpDouble(radiusLarge, other.radiusLarge, t)!,
      radiusPill: lerpDouble(radiusPill, other.radiusPill, t)!,
      edgeMarginMobile: lerpDouble(edgeMarginMobile, other.edgeMarginMobile, t)!,
      edgeMarginDesktop: lerpDouble(edgeMarginDesktop, other.edgeMarginDesktop, t)!,
      appBarHeight: lerpDouble(appBarHeight, other.appBarHeight, t)!,
      bottomNavHeight: lerpDouble(bottomNavHeight, other.bottomNavHeight, t)!,
    );
  }
}
