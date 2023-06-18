import 'package:flutter/material.dart';
import 'package:playx_theme/src/model/colors/dark_color_scheme.dart';
import 'package:playx_theme/src/model/colors/light_color_scheme.dart';
import 'package:playx_theme/src/model/x_theme.dart';

/// Theme config :
/// used to configure out app theme by providing the app with the needed themes.
/// Create a class that extends the [XThemeConfig] class to implement your own themes.
/// defaults to [XDefaultThemeConfig].
abstract class XThemeConfig {
  const XThemeConfig();

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
            theme: ThemeData.light(),
            colorScheme: LightColorScheme()),
        XTheme(
            id: 'dark',
            name: 'Dark',
            theme: ThemeData.dark(),
            colorScheme: DarkColorScheme()),
      ];
}
