import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/model/colors/dark_colors.dart';
import 'package:playx_theme/src/model/colors/light_colors.dart';

/// Theme config :
/// used to configure out app theme by providing the app with the needed themes.
/// Create a class that extends the [XThemeConfig] class to implement your own themes.
/// defaults to [XDefaultThemeConfig].
abstract class XThemeConfig {
  const XThemeConfig();

  int get defaultThemeIndex => 0;

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
            ),
            colors: LightColorScheme()),
        XTheme(
            id: 'dark',
            name: 'Dark',
            theme: (locale) => ThemeData.dark(),
            colors: DarkColorScheme()),
      ];

  ///set default theme to light or dark based on device dark mode.
  @override
  int get defaultThemeIndex => PlayxTheme.isDeviceInDarkMode() ? 1 :0;
}
