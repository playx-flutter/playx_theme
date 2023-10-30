import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// Theme config :
/// used to configure out app theme by providing the app with the needed themes.
/// Create a class that extends the [XThemeConfig] class to implement your own themes.
/// defaults to [XDefaultThemeConfig].
abstract class XThemeConfig {
  const XThemeConfig();

  /// Index of the initial theme to start the app with.
  int get initialThemeIndex => 0;

  /// Whether to save the theme index to the device storage or not.
  bool get saveTheme => true;

  /// List of themes to use in the app.
  List<XTheme> get themes;
}

///Default theme configuration.
class XDefaultThemeConfig extends XThemeConfig {
  const XDefaultThemeConfig() : super();

  @override
  List<XTheme> get themes => [
        XTheme(
            id: 'light',
            name: 'Light',
            theme: (locale) => ThemeData(
                  brightness: Brightness.light,
                  colorScheme:  ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light,),
              useMaterial3: true,
                ),
            cupertinoTheme: (locale) => const CupertinoThemeData(
                  brightness: Brightness.light,
                ),
            isDark: false,
            colors: const XColors()),
        XTheme(
            id: 'dark',
            name: 'Dark',
            theme: (locale) => ThemeData(
                  brightness: Brightness.dark,
              colorScheme:  ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark,),
              useMaterial3: true,
            ),
            cupertinoTheme: (locale) => const CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
            isDark: true,
            colors: const XColors()),
      ];

  ///set default theme to light or dark based on device dark mode.
  @override
  int get initialThemeIndex => PlayxTheme.isDeviceInDarkMode() ? 1 : 0;
}
