import 'package:flutter/material.dart';
import 'package:playx_theme/x_theme.dart';

abstract class XThemeConfig {
  const XThemeConfig();
  List<XTheme> get themes;
}

class XDefualtThemeConfig extends XThemeConfig {
  const XDefualtThemeConfig() : super();

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
