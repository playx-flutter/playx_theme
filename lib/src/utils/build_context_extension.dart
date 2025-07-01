import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

extension BuildContextExtension on BuildContext {
  XTheme get xTheme {
    final XTheme? inheritedTheme = XTheme.maybeOf(this);
    if (inheritedTheme == null) {
      throw FlutterError('No PlayxThemeBuilder found in context');
    }
    return inheritedTheme;
  }

  PlayxColors get playxColors {
    final PlayxColors? colors = PlayxColors.maybeOf(this);
    if (colors == null) {
      throw FlutterError('No PlayxColors found in context');
    }
    return colors;
  }

  /// Returns the [ThemeData] associated with the current context's theme.
  ThemeData get themeData {
    return xTheme.themeData;
  }

  /// Returns Whether the current theme is a dark theme.
  bool get isDarkMode {
    return xTheme.isDark;
  }
}
