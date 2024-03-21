import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

typedef ThemeSwitcherBuilder = Widget Function(
    BuildContext context, XTheme theme);

class PlayxThemeSwitcher extends StatelessWidget {
  final ThemeSwitcherBuilder builder;

  const PlayxThemeSwitcher({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return builder(ctx, PlayxTheme.currentTheme);
    });
  }
}
