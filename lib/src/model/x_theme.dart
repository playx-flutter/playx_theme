import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/src/widgets/playx_inherited_theme.dart';

import 'playx_colors.dart';

/// Class that defines the theme for the app.
class XTheme extends Equatable {
  ///  id for the theme.
  final String id;

  ///Defines theme name.
  final String name;

  /// Defines the configuration of the overall visual [Theme] for a [MaterialApp]
  /// or a widget subtree within the app.
  final ThemeData themeData;

  /// Defines the configuration of the overall visual [Theme] for a [CupertinoApp]
  /// or a widget subtree within the app.
  final CupertinoThemeData? cupertinoThemeData;

  /// Defines the configuration of the overall visual [Theme] for a [MaterialApp]
  /// or a widget subtree within the app.
  /// This can be used to provide a custom theme for the app based on the locale.
  final ThemeData Function(Locale? locale)? themeBuilder;

  /// Defines the configuration of the overall visual [Theme] for a [CupertinoApp]
  /// or a widget subtree within the app.
  /// This is used to provide a custom theme for the app based on the locale.
  final CupertinoThemeData Function(Locale? locale)? cupertinoThemeBuilder;

  /// color scheme for the theme which provides custom colors for each theme.
  final PlayxColors colors;

  /// Defines Whether the provided theme is dark or not.
  final bool isDark;

  const XTheme({
    required this.id,
    required this.name,
    required this.themeData,
    this.cupertinoThemeData,
    this.colors = const DefaultColors(),
    this.isDark = false,
  })  : themeBuilder = null,
        cupertinoThemeBuilder = null;

  const XTheme.builder({
    required this.id,
    required this.name,
    required ThemeData initialTheme,
    required this.themeBuilder,
    this.cupertinoThemeBuilder,
    this.colors = const DefaultColors(),
    this.isDark = false,
  })  : themeData = initialTheme,
        cupertinoThemeData = null;

  @override
  List<Object> get props => [
        id,
        name,
      ];

  @override
  bool get stringify => true;

  static XTheme of(BuildContext context) {
    return PlayxInheritedTheme.of(context).theme;
  }

  static XTheme? maybeOf(BuildContext context) {
    return PlayxInheritedTheme.maybeOf(context)?.theme;
  }
}
