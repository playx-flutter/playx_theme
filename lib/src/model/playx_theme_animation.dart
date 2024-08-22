import 'dart:ui';

import '../../playx_theme.dart';

class PlayxThemeAnimation {
  final PlayxThemeAnimationType type;
  final bool? isReversed;
  final ThemeSwitcherClipper? clipper;
  final Offset? offset;
  final VoidCallback? onAnimationFinish;
  final Duration duration;

  const PlayxThemeAnimation({
    this.type = PlayxThemeAnimationType.clipper,
    this.isReversed,
    this.clipper,
    this.offset,
    this.onAnimationFinish,
    this.duration = const Duration(milliseconds: 300),
  });
}
