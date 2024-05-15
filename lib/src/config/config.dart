import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// Theme config :
/// used to configure out app theme by providing the app with the needed themes.
/// Create a class that extends the [PlayxThemeConfig] class to implement your own themes.
/// defaults to [XDefaultThemeConfig].
class PlayxThemeConfig {
  /// Index of the initial theme to start the app with.
  final int initialThemeIndex;

  /// Whether to save the theme index to the device storage or not.
  final bool saveTheme;

  /// List of themes to use in the app.
  List<XTheme> themes;

  PlayxThemeConfig({
    this.initialThemeIndex = 0,
    this.saveTheme = true,
    this.themes = const [],
  })  : assert(initialThemeIndex >= 0 && initialThemeIndex < themes.length),
        assert(themes.isNotEmpty);
}

///Default theme configuration.
class XDefaultThemeConfig extends PlayxThemeConfig {
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
