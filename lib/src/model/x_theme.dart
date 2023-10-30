import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/src/model/x_color_scheme.dart';

/// wrapper around flutter `ThemeData`.
/// used to define current app theme.
class XTheme extends Equatable {
  ///  id for the theme.
  final String id;

  ///Defines theme name.
  final String name;

  /// Defines the configuration of the overall visual [Theme] for a [MaterialApp]
  /// or a widget subtree within the app.
  final ThemeData Function(Locale locale) theme;

  /// Defines the configuration of the overall visual [Theme] for a [CupertinoApp]
  /// or a widget subtree within the app.
  final CupertinoThemeData Function(Locale locale)? cupertinoTheme;

  /// color scheme for the theme which provides custom colors for each theme.
  final XColors colors;

  /// Defines Whether the provided theme is dark or not.
  final bool isDark;

  const XTheme({
    required this.id,
    required this.name,
    required this.theme,
    this.cupertinoTheme,
    this.colors = const DefaultColors(),
    this.isDark = false,
  });

  @override
  List<Object> get props => [
        id,
        name,
      ];
}
