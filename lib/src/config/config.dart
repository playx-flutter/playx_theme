import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// Theme config :
/// Used to configure the app's theme by specifying the available themes,
/// the initial theme index, and whether to save the selected theme to device storage.
class PlayxThemeConfig {
  /// Index of the initial theme to start the app with.
  final int initialThemeIndex;

  /// Whether to save the theme index to the device storage or not.
  final bool saveTheme;

  /// List of themes to use in the app.
  List<XTheme> themes;

  /// Whether to migrate preferences to asynchronous preferences.
  final bool migratePrefsToAsyncPrefs;

  /// Creates a [PlayxThemeConfig] instance.
  ///
  /// The [initialThemeIndex] must be non-negative and less than the length of [themes].
  /// The [themes] list must not be empty.
  PlayxThemeConfig({
    this.initialThemeIndex = 0,
    this.saveTheme = true,
    this.themes = const [],
    this.migratePrefsToAsyncPrefs = false,
  })  : assert(initialThemeIndex >= 0 && initialThemeIndex < themes.length),
        assert(themes.isNotEmpty);
}

/// Default theme configuration.
class XDefaultThemeConfig extends PlayxThemeConfig {
  /// Creates a default [XDefaultThemeConfig] instance with predefined light and dark themes.
  ///
  /// The initial theme is determined based on the device's current theme mode.
  XDefaultThemeConfig()
      : super(themes: [
          XTheme(
              id: 'light',
              name: 'Light',
              themeData: ThemeData(
                  brightness: Brightness.light,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: Brightness.light,
                  )),
              cupertinoThemeData: const CupertinoThemeData(
                brightness: Brightness.light,
              ),
              isDark: false,
              colors: const PlayxColors()),
          XTheme(
            id: 'dark',
            name: 'Dark',
            themeData: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            cupertinoThemeData: const CupertinoThemeData(
              brightness: Brightness.dark,
            ),
            isDark: true,
            colors: const PlayxColors(),
          ),
        ], initialThemeIndex: PlayxTheme.isDeviceInDarkMode() ? 1 : 0);
}
