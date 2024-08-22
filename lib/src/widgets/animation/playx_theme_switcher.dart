import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// Defines a callback function that takes the
/// current [XTheme] and builds a widget based on that theme.
typedef ThemeSwitcherBuilder = Widget Function(
    BuildContext context, XTheme theme);

/// A [StatelessWidget] that allows for building widgets based on the current [XTheme].
///
/// This widget uses a [ThemeSwitcherBuilder] to build its child widget with the current
/// theme provided by [PlayxTheme]. It provides context and theme information
//   /// for changing the theme, especially useful for animations like [PlayxThemeClipperAnimation]. allowing you to use the widget’s offset and context for precise animation control.
class PlayxThemeSwitcher extends StatelessWidget {
  /// Creates a [PlayxThemeSwitcher] that provides context and theme information
  /// for changing the theme, especially useful for animations like [PlayxThemeClipperAnimation].
  ///
  /// The [builder] function is called with the [BuildContext] and the current [XTheme],
  /// allowing you to use the widget’s offset and context for precise animation control.
  ///
  /// Usage:
  /// ```dart
  /// PlayxThemeSwitcher(
  ///   builder: (context, theme) {
  ///     return Container(
  ///       color: theme.colors.backgroundColor,
  ///       child: Text('Hello, Theme!'),
  ///     );
  ///   },
  /// );
  /// ```
  final ThemeSwitcherBuilder builder;

  const PlayxThemeSwitcher({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        // Retrieve the current theme and pass it to the builder
        return builder(ctx, PlayxTheme.currentTheme);
      },
    );
  }
}
