import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

import '../controller/controller.dart';

typedef ThemeBuilder = Widget Function(BuildContext, XTheme theme);

class PlayxThemeBuilder extends StatefulWidget {
  const PlayxThemeBuilder({
    super.key,
    this.builder,
    this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : assert(builder != null || child != null);

  final ThemeBuilder? builder;
  final Widget? child;
  final Duration duration;

  @override
  State<PlayxThemeBuilder> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<PlayxThemeBuilder>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  final themeController = Get.find<XThemeController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    themeController.updateThemeAnimationController(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<XThemeController>();
    return ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, xTheme, _) {
          return RepaintBoundary(
            key: controller.previewContainer,
            child: widget.child ?? widget.builder!(context, xTheme),
          );
        });
  }

  @override
  void dispose() {
    themeController.updateThemeAnimationController(null);
    super.dispose();
  }
}
