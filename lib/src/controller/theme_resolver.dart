import 'package:flutter/material.dart';

import '../config/config.dart';
import '../model/x_theme.dart';

/// The theme and mode the app should start with.
typedef ResolvedTheme = ({XTheme theme, ThemeMode mode});

/// Pure helpers that decide which theme / mode to use for a
/// [PlayxThemeConfig]. They hold no state so they are easy to test.
abstract final class ThemeResolver {
  static bool _validIndex(int? index, int length) =>
      index != null && index >= 0 && index < length;

  /// The theme to use for light ([isDark] false) or dark mode.
  ///
  /// Uses `lightThemeIndex` / `darkThemeIndex` when set, otherwise the first
  /// matching theme. Returns `null` if there is none.
  static XTheme? themeForBrightness(PlayxThemeConfig config, bool isDark) {
    final index = isDark ? config.darkThemeIndex : config.lightThemeIndex;
    if (_validIndex(index, config.themes.length)) return config.themes[index!];
    return config.themes.where((t) => t.isDark == isDark).firstOrNull;
  }

  /// The explicitly configured initial mode, or [ThemeMode.system].
  static ThemeMode initialMode(PlayxThemeConfig config) {
    if (_validIndex(config.initialThemeIndex, config.themes.length)) {
      return config.themes[config.initialThemeIndex!].isDark
          ? ThemeMode.dark
          : ThemeMode.light;
    }
    return config.initialThemeMode ?? ThemeMode.system;
  }

  /// The initial theme: `initialThemeIndex`, then `initialThemeMode`, then the
  /// device brightness. Falls back to the first theme.
  static XTheme initialTheme(
    PlayxThemeConfig config, {
    required bool deviceIsDark,
  }) {
    if (_validIndex(config.initialThemeIndex, config.themes.length)) {
      return config.themes[config.initialThemeIndex!];
    }
    final isDark = switch (config.initialThemeMode) {
      ThemeMode.light => false,
      ThemeMode.dark => true,
      ThemeMode.system || null => deviceIsDark,
    };
    return themeForBrightness(config, isDark) ?? config.themes.first;
  }

  /// Decides the theme and mode to boot with from what was saved.
  ///
  /// - A saved mode wins; an unknown mode name falls back to system.
  /// - With only a saved index (e.g. from v1) the user picked that theme
  ///   explicitly, so the mode is derived from it.
  /// - With nothing saved the configured initial theme and mode are used.
  static ResolvedTheme resolveBoot(
    PlayxThemeConfig config, {
    required int? savedIndex,
    required String? savedMode,
    required bool deviceIsDark,
  }) {
    final themes = config.themes;
    final hasIndex = _validIndex(savedIndex, themes.length);

    final ThemeMode mode;
    if (savedMode != null) {
      mode = ThemeMode.values.firstWhere(
        (e) => e.name == savedMode,
        orElse: () => ThemeMode.system,
      );
    } else if (hasIndex) {
      mode = themes[savedIndex!].isDark ? ThemeMode.dark : ThemeMode.light;
    } else {
      mode = initialMode(config);
    }

    final XTheme theme;
    if (savedMode != null && mode == ThemeMode.system) {
      theme = themeForBrightness(config, deviceIsDark) ?? themes.first;
    } else if (hasIndex) {
      theme = themes[savedIndex!];
    } else if (savedMode == null) {
      theme = initialTheme(config, deviceIsDark: deviceIsDark);
    } else {
      theme =
          themeForBrightness(config, mode != ThemeMode.light) ?? themes.first;
    }
    return (theme: theme, mode: mode);
  }
}
