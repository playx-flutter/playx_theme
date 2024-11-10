import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/src/widgets/playx_inherited_theme.dart';

import 'playx_colors.dart';

/// A class that defines the theme settings for the application.
class XTheme extends Equatable {
  /// A unique identifier for the theme.
  final String id;

  /// The name of the theme, typically used for display purposes.
  final String name;

  /// The [ThemeData] that defines the visual styling for a [MaterialApp] or
  /// a widget subtree within the app.
  final ThemeData themeData;

  /// The [CupertinoThemeData] that defines the visual styling for a [CupertinoApp] or
  /// a widget subtree within the app.
  final CupertinoThemeData? cupertinoThemeData;

  /// A function that returns [ThemeData] based on the locale, allowing for
  /// custom theme configurations that adapt to different locales.
  final ThemeData Function(Locale? locale)? themeBuilder;

  /// A function that returns [CupertinoThemeData] based on the locale, allowing for
  /// custom theme configurations that adapt to different locales.
  final CupertinoThemeData Function(Locale? locale)? cupertinoThemeBuilder;

  /// A custom color scheme for the theme, represented by the [PlayxColors] class,
  /// which provides custom colors specific to each theme.
  final PlayxColors colors;

  /// Indicates whether the theme is a dark theme. Defaults to `false`.
  final bool isDark;

  /// Creates an [XTheme] instance with the provided configurations.
  ///
  /// The [id], [name], and [themeData] parameters are required.
  /// The [cupertinoThemeData] can be provided if the app supports Cupertino styling.
  /// The [colors] parameter allows customization of the theme's color scheme,
  /// and [isDark] indicates whether the theme is dark or not.
  const XTheme({
    required this.id,
    required this.name,
    required this.themeData,
    this.cupertinoThemeData,
    this.colors = const DefaultColors(),
    this.isDark = false,
  })  : themeBuilder = null,
        cupertinoThemeBuilder = null;

  /// Creates an [XTheme] instance with a builder function for dynamic theming
  /// based on the app's locale.
  ///
  /// The [id], [name], and [initialTheme] parameters are required.
  /// The [themeBuilder] allows for the creation of custom themes that adapt to different locales.
  /// The [cupertinoThemeBuilder] can be used to provide Cupertino-specific theme configurations.
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
  String toString() {
    return 'XTheme(id: $id, name: $name)';
  }

  /// Retrieves the current [XTheme] from the [BuildContext].
  ///
  /// This method can be used to access the theme settings for the current context.
  static XTheme of(BuildContext context) {
    return PlayxInheritedTheme.of(context).theme;
  }

  /// Tries to retrieve the current [XTheme] from the [BuildContext].
  ///
  /// Returns `null` if there is no [XTheme] available in the current context.
  static XTheme? maybeOf(BuildContext context) {
    return PlayxInheritedTheme.maybeOf(context)?.theme;
  }
}
