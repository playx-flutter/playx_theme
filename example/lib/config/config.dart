import 'package:example/colors/dark_colors.dart';
import 'package:example/colors/light_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// used to configure out app theme by providing the app with the needed themes.
class ThemeConfig extends XThemeConfig {
  const ThemeConfig() : super();

  static LightColorScheme lightColors = LightColorScheme();
  static DarkColorScheme darkColors = DarkColorScheme();

  @override
  List<XTheme> get themes => [
        XTheme(
            id: 'light',
            name: 'Light',
            theme: (locale) => ThemeData(
                  brightness: Brightness.light,
                  colorScheme: lightColors.colorScheme,
                  useMaterial3: true,
                ),
            cupertinoTheme: (locale) => const CupertinoThemeData(
                  brightness: Brightness.light,
                ),
            colors: lightColors),
        XTheme(
            id: 'dark',
            name: 'Dark',
            theme: (locale) => ThemeData(
                  brightness: Brightness.dark,
                  colorScheme: darkColors.colorScheme,
                  useMaterial3: true,
                ),
            cupertinoTheme: (locale) => const CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
            colors: darkColors),
      ];

  ///set default theme to light or dark based on device dark mode.
  @override
  int get defaultThemeIndex => PlayxTheme.isDeviceInDarkMode() ? 1 : 0;
}
