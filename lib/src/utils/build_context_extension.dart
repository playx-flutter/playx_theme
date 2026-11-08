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

  /// Returns the [ThemeExtension] of type [T] of the current theme, or `null`
  /// if the theme doesn't register one in `ThemeData.extensions`.
  T? maybeThemeExtension<T extends ThemeExtension<T>>() =>
      xTheme.extension<T>();

  /// Returns the [ThemeExtension] of type [T] of the current theme.
  ///
  /// Throws a [FlutterError] if the theme doesn't register one.
  T themeExtension<T extends ThemeExtension<T>>() {
    final extension = maybeThemeExtension<T>();
    if (extension == null) {
      throw FlutterError(
        'No ThemeExtension of type $T found in the current theme',
      );
    }
    return extension;
  }

  /// Returns the app's current [ThemeMode] (light, dark or system).
  ///
  /// This is not reactive on its own; listen to `PlayxTheme.themeModeNotifier`
  /// if you need to rebuild when only the mode changes.
  ThemeMode get themeMode => PlayxTheme.themeMode;
}
