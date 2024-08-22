import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/widgets/playx_inherited_theme.dart';

import '../controller/controller.dart';

/// A function that takes the [BuildContext] and the current [XTheme], and returns
/// a [Widget] to be built with the current theme.
typedef ThemeBuilder = Widget Function(BuildContext, XTheme theme);

/// A widget that provides a way to build a subtree with the current theme.
///
/// The `PlayxThemeBuilder` widget allows you to build UI elements based on the
/// current theme by providing a `ThemeBuilder` function. You can also pass
/// a child widget that will be built with the current theme.
class PlayxThemeBuilder extends StatefulWidget {
  /// Creates a `PlayxThemeBuilder` widget.
  ///
  /// The `builder` parameter is a function that takes the [BuildContext] and
  /// the current [XTheme], and returns a [Widget] to be displayed.
  ///
  /// The `child` parameter is a widget that will be built using the current theme.
  ///
  /// Either `builder` or `child` must be provided.
  const PlayxThemeBuilder({
    super.key,
    this.builder,
    this.child,
  }) : assert(builder != null || child != null,
            'Either `builder` or `child` must be provided.');

  /// A function that takes the [BuildContext] and the current [XTheme], and returns
  /// a [Widget] to be built with the current theme.
  final ThemeBuilder? builder;

  /// A widget that will be built with the current theme.
  final Widget? child;

  @override
  State<PlayxThemeBuilder> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<PlayxThemeBuilder>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  final themeController = XThemeController.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    themeController.updateThemeAnimationController(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final controller = XThemeController.instance;
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, xTheme, _) {
        return PlayxInheritedTheme(
          theme: xTheme,
          child: RepaintBoundary(
            key: controller.previewContainer,
            child: widget.child ?? widget.builder!(context, xTheme),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    themeController.updateThemeAnimationController(null);
    super.dispose();
  }
}
