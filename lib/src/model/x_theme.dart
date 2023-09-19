import 'package:flutter/material.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/src/model/x_color_scheme.dart';

/// wrapper around flutter `ThemeData`.
/// used to define current app theme.
class XTheme extends Equatable {
  /// Defines the configuration of the overall visual [Theme] for a [MaterialApp]
  /// or a widget subtree within the app.
  final ThemeData Function( Locale locale) theme;

  /// id for the theme.
  final String id;

  /// build theme name.
  final String name;

  /// color scheme for the theme which provides custom colors for each theme.
  final XColors colors;

  const XTheme({
    required this.theme,
    required this.id,
    required this.name,
     this.colors =const DefaultColors(),
  });

  @override
  List<Object> get props => [
        id,
        name,
      ];
}
