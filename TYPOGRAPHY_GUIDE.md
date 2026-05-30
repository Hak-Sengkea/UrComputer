# Typography System - Setup Guide

## Overview
This project uses Material Design 3 typography with:
- **Headings**: Space Mono (semi-bold monospace) - modern and techy
- **Body**: Inter (clean sans-serif) - highly readable

## File Structure
```
lib/theme/
├── app_theme.dart        # Main theme configuration
├── app_text_style.dart   # Typography styles (Display, Headline, Title, Body, Label)
└── app_colors.dart       # (Optional) For future color system
```

## Font Installation

### Step 1: Download Fonts
Download the fonts from Google Fonts:
- **Space Mono**: https://fonts.google.com/specimen/Space+Mono
- **Inter**: https://fonts.google.com/specimen/Inter

### Step 2: Create Fonts Directory
Create a `fonts/` directory in the project root:
```
project-root/
├── lib/
├── assets/
└── fonts/  ← Create here
    ├── SpaceMono-Regular.ttf
    ├── SpaceMono-Bold.ttf
    ├── Inter-Regular.ttf
    ├── Inter-Medium.ttf
    ├── Inter-SemiBold.ttf
    └── Inter-Bold.ttf
```

### Step 3: pubspec.yaml Configuration
The fonts section is already configured in `pubspec.yaml`. After adding font files, run:
```bash
flutter pub get
```

## Usage Examples

### In Dart/Flutter Code
```dart
import 'package:mobile/theme/app_text_style.dart';

// Using predefined styles
Text('Display Large', style: AppTextStyle.displayLarge),
Text('Heading Medium', style: AppTextStyle.headlineMedium),
Text('Body Large', style: AppTextStyle.bodyLarge),
Text('Label Small', style: AppTextStyle.labelSmall),

// Or use Material TextTheme
Text('Hello', style: Theme.of(context).textTheme.headlineLarge),
Text('Body text', style: Theme.of(context).textTheme.bodyLarge),
```

## Typography Hierarchy

### Display Styles (Large promotional text)
- `displayLarge` (57sp) - Space Mono Semi-bold
- `displayMedium` (45sp) - Space Mono Semi-bold
- `displaySmall` (36sp) - Space Mono Semi-bold

### Headline Styles (Section headings)
- `headlineLarge` (32sp) - Space Mono Semi-bold
- `headlineMedium` (28sp) - Space Mono Semi-bold
- `headlineSmall` (24sp) - Space Mono Semi-bold

### Title Styles (Subheadings)
- `titleLarge` (22sp) - Inter Semi-bold
- `titleMedium` (16sp) - Inter Semi-bold
- `titleSmall` (14sp) - Inter Semi-bold

### Body Styles (Regular text)
- `bodyLarge` (16sp) - Inter Regular
- `bodyMedium` (14sp) - Inter Regular
- `bodySmall` (12sp) - Inter Regular

### Label Styles (Buttons, badges, chips)
- `labelLarge` (14sp) - Inter Semi-bold
- `labelMedium` (12sp) - Inter Semi-bold
- `labelSmall` (11sp) - Inter Semi-bold

## Design Philosophy
✓ **Clear & Readable** - Proper line height and letter spacing
✓ **Modern & Techy** - Space Mono for headings, Inter for body
✓ **Accessible** - Color contrast and size hierarchy
✓ **Consistent** - Centralized typography management
