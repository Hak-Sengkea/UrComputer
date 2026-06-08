# Centralized Styling & Typography Guide

This guide establishes the styling rules and system configuration for the UrComputer Flutter application. To support dynamic theme toggling and keep widgets decoupled, **we enforce using the centralized theme system accessed via the BuildContext**.

---

## 1. File Structure

All theme and style assets are managed centrally in `lib/theme/`:

```
lib/theme/
├── app_theme.dart           # Global lightTheme and darkTheme configuration
├── app_colors.dart          # Hex code definitions for core colors
├── app_text_style.dart      # Material 3 Font metrics and weights
├── theme_extensions.dart    # AppColorsExtension & AppSizesExtension for custom tokens
└── theme_context.dart       # BuildContext extensions (Shortcuts to access styles)
```

---

## 2. The Golden Rule of Styling

> ❌ **Never import or use static classes directly inside widgets:**
> `import 'package:mobile/theme/app_colors.dart';` $\rightarrow$ `AppColors.brandBlue`
> `import 'package:mobile/theme/app_text_style.dart';` $\rightarrow$ `AppTextStyle.displayLarge`
> `import 'package:mobile/const/app_sizes.dart';` $\rightarrow$ `AppSizes.space16`

>  **Always query properties reactively through the BuildContext:**
> `import 'package:mobile/theme/theme_context.dart';`
> Use: `context.colorScheme.primary`
> Use: `context.textTheme.displayLarge`
> Use: `context.customColors.neonCyan`
> Use: `context.sizes.space16`

---

## 3. Centralized Theme Access Shortcuts

By importing `import 'package:mobile/theme/theme_context.dart';`, you get direct, short access to all centralized tokens:

| Context Shortcut | Mapped to ThemeData Property | Description |
| :--- | :--- | :--- |
| `context.theme` | `Theme.of(context)` | Accesses the active ThemeData |
| `context.colorScheme` | `Theme.of(context).colorScheme` | Standard M3 colors (`primary`, `surface`, etc.) |
| `context.textTheme` | `Theme.of(context).textTheme` | Standard M3 typography (`bodyMedium`, etc.) |
| `context.customColors` | `Theme.extension<AppColorsExtension>()` | Neon gradients, card colors, warning/success |
| `context.sizes` | `Theme.extension<AppSizesExtension>()` | Centralized spacing values, corner radii, margins |

---

## 4. Spacing & Corner Radii (`context.sizes`)

All spacing and radius tokens are centralized in the theme. If you need to pad a widget or round a corner, use `context.sizes` to keep the layout consistent:

```dart
Padding(
  padding: EdgeInsets.all(context.sizes.space16), // 16dp spacing
  child: ClipRRect(
    borderRadius: BorderRadius.circular(context.sizes.radiusMedium), // 12dp radius
    child: Container(
      color: context.customColors.cardBg, // Card background
    ),
  ),
)
```

---

## 5. Custom Colors & Gradients (`context.customColors`)

Use this for custom project assets (such as neon colors and linear gradients) that don't fit the standard Material `ColorScheme`:

```dart
Container(
  decoration: BoxDecoration(
    gradient: context.customColors.primaryGradient, // Neon Cyan -> Neon Purple
  ),
)
```
