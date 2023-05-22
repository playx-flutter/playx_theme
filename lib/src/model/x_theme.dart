import 'package:flutter/material.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/src/model/x_color_scheme.dart';

/// wrapper around flutter `ThemeData`.
/// used to define current app theme.
class XTheme extends Equatable {
  /// Defines the configuration of the overall visual [Theme] for a [MaterialApp]
  /// or a widget subtree within the app.
  final ThemeData theme;

  /// id for the theme.
  final String id;

  /// build theme name.
  final String Function() nameBuilder;

  final XColorScheme colorScheme;

  const XTheme({
    required this.theme,
    required this.id,
    required this.nameBuilder,
    required this.colorScheme,
  });

  @override
  List<Object> get props => [
        id,
        theme,
        nameBuilder(),
      ];
}
