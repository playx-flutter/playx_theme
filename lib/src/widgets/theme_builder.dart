import 'package:flutter/material.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/src/controller/controller.dart';
import 'package:playx_theme/src/model/x_theme.dart';

///PlayXThemeBuilder:
///It allows us to create a widget with current theme.
///It should rebuild the widget automatically after changing the theme.
class PlayXThemeBuilder extends StatelessWidget {
  final Widget Function(XTheme xTheme) builder;

  const PlayXThemeBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return GetBuilder<XThemeController>(
      builder: (c) => builder(c.currentXTheme),
    );
  }
}
