# UrComputer Design System & Centralized Styling Guide

This directory manages the core styling tokens (typography, sizes, colors, and gradients) for the UrComputer Flutter application. To maintain visual consistency and support dynamic theme switching, **widgets must never reference static styling constants directly**. Instead, all styling is retrieved reactively from the `BuildContext`.

---

## The Golden Rule of Styling

> ❌ **Never import raw colors, styles, or sizes in widgets:**
> ```dart
> import 'package:mobile/theme/app_colors.dart';       // ❌ PROHIBITED
> import 'package:mobile/theme/app_text_style.dart';   // ❌ PROHIBITED
> import 'package:mobile/const/app_sizes.dart';        // ❌ PROHIBITED
> ```

>  **Only import `theme_context.dart` and query properties reactively:**
> ```dart
> import 'package:mobile/theme/theme_context.dart';     //  CORRECT
> 
> color: context.colorScheme.primary,
> style: context.textTheme.headlineMedium,
> padding: EdgeInsets.all(context.sizes.space16),
> ```

---

## How to Extend the Styling System

When your team needs to add new styles, spacing, or colors, use the following blueprints:

### 1. Adding a new Spacing or Corner Radius (e.g. `space64`)

1. Open `lib/theme/theme_extensions.dart`:
   - Add the property to `AppSizesExtension`:
     ```dart
     final double space64;
     ```
   - Update the constructor:
     ```dart
     const AppSizesExtension({ ..., required this.space64 });
     ```
   - Update the `copyWith` method:
     ```dart
     space64: space64 ?? this.space64,
     ```
   - Update the `lerp` method:
     ```dart
     space64: lerpDouble(space64, other.space64, t)!,
     ```

2. Open `lib/theme/app_theme.dart` and assign the actual value inside `_sharedSizes`:
   ```dart
   static final _sharedSizes = const AppSizesExtension(
     // ...
     space64: 64.0, // Add value here
   );
   ```

* **Usage in code:** `context.sizes.space64`

---

### 2. Adding a new Custom Color or Gradient (e.g. `neonGreen`)

1. Open `lib/theme/theme_extensions.dart`:
   - Add the property to `AppColorsExtension`:
     ```dart
     final Color neonGreen;
     ```
   - Add the new property to the constructor, `copyWith`, and `lerp` methods using the same pattern as sizes.

2. Open `lib/theme/app_theme.dart` and define the hex color in `_sharedColors`:
   ```dart
   static final _sharedColors = const AppColorsExtension(
     // ...
     neonGreen: Color(0xFF00FF66), // Add value here
   );
   ```

* **Usage in code:** `context.customColors.neonGreen`

---

### 3. Adding or Modifying a Text Style

Our text styles are mapped directly to Material 3 slots (e.g., `displayLarge`, `bodyMedium`). 

* **To tweak font metrics (font size, letter spacing, weight):**
  Open `lib/theme/app_text_style.dart` and edit the values. They will propagate globally.
* **To request a standard style in widgets:**
  Use `context.textTheme.titleMedium` (configured via `app_theme.dart`).
