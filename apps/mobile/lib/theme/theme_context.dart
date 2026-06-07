import 'package:flutter/material.dart';
import 'theme_extensions.dart';
export 'theme_extensions.dart';

extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  AppColorsExtension get customColors => theme.extension<AppColorsExtension>()!;
  AppSizesExtension get sizes => theme.extension<AppSizesExtension>()!;
}
