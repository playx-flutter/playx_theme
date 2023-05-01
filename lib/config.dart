import 'package:flutter/material.dart';
import 'package:playx_theme/x_theme.dart';

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
          id: 'dark',
          nameBuilder: () => 'Dark',
          theme: ThemeData.dark(),
        ),
        XTheme(
          id: 'light',
          nameBuilder: () => 'Light',
          theme: ThemeData.light(),
        ),
      ];
}
