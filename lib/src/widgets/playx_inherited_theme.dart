import 'package:flutter/material.dart';
import 'package:playx_theme/src/model/x_theme.dart';

/// An [InheritedWidget] that provides access to the current [XTheme] in the widget tree.
///
/// This widget allows child widgets to access the current theme without having to
/// pass it down the widget tree manually. It is typically used in conjunction with
/// [PlayxThemeBuilder] to provide the current theme to descendant widgets.
class PlayxInheritedTheme extends InheritedWidget {
  /// Creates a [PlayxInheritedTheme] widget.
  ///
  /// The [theme] parameter is required and specifies the current theme to be provided
  /// to the subtree. The [child] parameter is also required and represents the subtree
  /// that will be built with the provided theme.
  const PlayxInheritedTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  /// The current [XTheme] being provided to the widget subtree.
  final XTheme theme;

  /// Retrieves the closest [PlayxInheritedTheme] instance from the widget tree.
  ///
  /// Returns `null` if no [PlayxInheritedTheme] is found in the context.
  ///
  /// Usage:
  /// ```dart
  /// final PlayxInheritedTheme? inheritedTheme = PlayxInheritedTheme.maybeOf(context);
  /// ```
  static PlayxInheritedTheme? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PlayxInheritedTheme>();

  /// Retrieves the closest [PlayxInheritedTheme] instance from the widget tree.
  ///
  /// Throws an assertion error if no [PlayxInheritedTheme] is found in the context.
  ///
  /// Usage:
  /// ```dart
  /// final PlayxInheritedTheme inheritedTheme = PlayxInheritedTheme.of(context);
  /// ```
  static PlayxInheritedTheme of(BuildContext context) {
    final PlayxInheritedTheme? result = maybeOf(context);
    if (result == null) {
      throw FlutterError(
          'PlayxInheritedTheme.of() called with a context that does not contain a PlayxInheritedTheme.\n'
          'No PlayxInheritedTheme ancestor could be found starting from the context that was passed to PlayxInheritedTheme.of(). '
          'This can happen because you do not have a PlayxThemeBuilder widget at the top of your widget tree.');
    }
    return result;
  }

  @override
  bool updateShouldNotify(PlayxInheritedTheme oldWidget) {
    // Notify if the theme has changed
    return oldWidget.theme != theme;
  }
}
