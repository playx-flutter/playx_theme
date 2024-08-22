import 'package:flutter/cupertino.dart';

import '../../playx_theme.dart';
import '../utils/animation_utils.dart';

/// Base class that defines theme animations and their settings in the Playx theme package.
///
/// This class provides common settings for theme animations, including the ability to reverse the animation,
/// set the duration, and handle actions when the animation finishes. Specific types of animations are represented
/// by subclasses such as [PlayxThemeClipperAnimation], [PlayxThemeFadeAnimation], [PlayxThemeScaleAnimation],
/// [PlayxThemeHorizontalSlideAnimation], and [PlayxThemeVerticalSlideAnimation].
sealed class PlayxThemeAnimation {
  /// Determines if the animation should be played in reverse.
  /// If set to `true`, the animation will run in the reverse direction.
  final bool isReversed;

  /// A callback function that is triggered when the animation finishes.
  /// You can use this to perform additional actions after the animation completes.
  final VoidCallback? onAnimationFinish;

  /// The duration of the animation. Defaults to 300 milliseconds.
  /// This controls how long the animation takes to complete.
  final Duration duration;

  /// Creates a [PlayxThemeAnimation] with customizable animation settings.
  ///
  /// The [duration] sets the time it takes for the animation to complete.
  /// You can reverse the animation using [isReversed], and [onAnimationFinish] allows you to perform an action once the animation is done.
  const PlayxThemeAnimation({
    this.isReversed = false,
    this.onAnimationFinish,
    this.duration = const Duration(milliseconds: 300),
  });

  /// Animates the selected [PlayxThemeAnimation] using the provided [controller].
  Future<void> animate({
    required AnimationController controller,
  });

  /// Creates a [PlayxThemeClipperAnimation] with custom clipping settings.
  /// As it create a clipping-based theme animation using a custom clipper.
  ///
  /// The [clipper] defines the clipping shape for the animation, and [offset] specifies the start or end position.
  /// The [context] is used to calculate the initial switcher position.
  factory PlayxThemeAnimation.clipper({
    ThemeSwitcherClipper clipper,
    Offset? offset,
    BuildContext? context,
    bool isReversed,
    VoidCallback? onAnimationFinish,
    Duration duration,
  }) = PlayxThemeClipperAnimation;

  /// Creates a [PlayxThemeFadeAnimation] that controls fade effects.
  /// As it create a fade animation effect with adjustable opacity levels.
  ///
  /// The [begin] and [end] parameters define the start and end opacity levels.
  const factory PlayxThemeAnimation.fade({
    double begin,
    double end,
    VoidCallback? onAnimationFinish,
    Duration duration,
  }) = PlayxThemeFadeAnimation;

  /// Creates a [PlayxThemeScaleAnimation] that controls scaling effects.
  /// As it create a scale animation effect with adjustable scale values.
  ///
  /// The [begin] and [end] parameters define the start and end scale values.
  const factory PlayxThemeAnimation.scale({
    double begin,
    double end,
    bool isReversed,
    VoidCallback? onAnimationFinish,
    Duration duration,
  }) = PlayxThemeScaleAnimation;

  /// Creates a [PlayxThemeHorizontalSlideAnimation] for horizontal slide effects.
  /// As it create a horizontal slide animation effect with adjustable start and end offsets.
  ///
  /// The [beginOffset] and [endOffset] parameters specify the start and end positions of the horizontal slide animation.
  const factory PlayxThemeAnimation.horizontalSlide({
    Offset beginOffset,
    Offset endOffset,
    bool isReversed,
    VoidCallback? onAnimationFinish,
    Duration duration,
  }) = PlayxThemeHorizontalSlideAnimation;

  /// Creates a [PlayxThemeVerticalSlideAnimation] for vertical slide effects.
  /// As it create a vertical slide animation effect with adjustable start and end offsets.
  ///
  /// The [beginOffset] and [endOffset] parameters specify the start and end positions of the vertical slide animation.
  const factory PlayxThemeAnimation.verticalSlide({
    Offset beginOffset,
    Offset endOffset,
    bool isReversed,
    VoidCallback? onAnimationFinish,
    Duration duration,
  }) = PlayxThemeVerticalSlideAnimation;
}

/// Defines a clipping-based theme animation using a custom clipper.
class PlayxThemeClipperAnimation extends PlayxThemeAnimation {
  /// A custom clipper that defines the clipping shape for the animation.
  /// This is useful when the animation requires clipping.
  final ThemeSwitcherClipper clipper;

  /// An offset value that can be used to define the start or end position of the animation.
  /// Useful for slide or offset-based animations.
  final Offset? offset;

  /// The calculated offset for the switcher position.
  final Offset switcherOffset;

  /// Creates a [PlayxThemeClipperAnimation] with custom clipping and offset settings.
  ///
  /// The [clipper] defines the clipping shape, and [offset] specifies the start or end position.
  /// The [context] is used to calculate the initial switcher position.
  PlayxThemeClipperAnimation({
    this.clipper = const ThemeSwitcherCircleClipper(),
    this.offset,
    BuildContext? context,
    super.isReversed,
    super.onAnimationFinish,
    super.duration,
  }) : switcherOffset = AnimationUtils.getSwitcherCoordinates(context, offset);

  @override
  Future<void> animate({required AnimationController controller}) async {
    if (isReversed) {
      await controller
          .reverse(from: 1.0)
          .then((value) => onAnimationFinish?.call());
    } else {
      await controller
          .forward(from: 0.0)
          .then((value) => onAnimationFinish?.call());
    }
  }
}

/// Defines a fade animation effect with adjustable opacity levels.
class PlayxThemeFadeAnimation extends PlayxThemeAnimation {
  /// The starting opacity value for the fade animation.
  final double begin;

  /// The ending opacity value for the fade animation.
  final double end;

  /// Creates a [PlayxThemeFadeAnimation] with specified fade values.
  ///
  /// The [begin] and [end] parameters define the opacity range for the animation.
  const PlayxThemeFadeAnimation({
    this.begin = 0,
    this.end = 1.0,
    super.onAnimationFinish,
    super.duration,
  })  : assert(begin >= 0),
        assert(end >= 0),
        assert(begin <= 1),
        assert(end <= 1);

  @override
  Future<void> animate({required AnimationController controller}) async {
    Tween(begin: begin, end: end).animate(controller);
    await controller
        .forward(from: 0.0)
        .then((value) => onAnimationFinish?.call());
  }
}

/// Defines a scale animation effect with adjustable scale values.
class PlayxThemeScaleAnimation extends PlayxThemeAnimation {
  /// The starting scale value for the scale animation.
  final double begin;

  /// The ending scale value for the scale animation.
  final double end;

  /// Creates a [PlayxThemeScaleAnimation] with specified scale values.
  ///
  /// The [begin] and [end] parameters define the scale range for the animation.
  const PlayxThemeScaleAnimation({
    this.begin = .5,
    this.end = 1.0,
    super.isReversed,
    super.onAnimationFinish,
    super.duration,
  })  : assert(begin >= 0),
        assert(end >= 0),
        assert(begin <= 1),
        assert(end <= 1);

  @override
  Future<void> animate({required AnimationController controller}) async {
    Tween(begin: begin, end: end).animate(controller);
    if (isReversed) {
      await controller
          .reverse(from: 1.0)
          .then((value) => onAnimationFinish?.call());
    } else {
      await controller
          .forward(from: 0.0)
          .then((value) => onAnimationFinish?.call());
    }
  }
}

/// Defines a horizontal slide animation effect with adjustable start and end offsets.
class PlayxThemeHorizontalSlideAnimation extends PlayxThemeAnimation {
  /// An offset value that defines the start position of the horizontal slide animation.
  final Offset beginOffset;

  /// An offset value that defines the end position of the horizontal slide animation.
  final Offset endOffset;

  /// Creates a [PlayxThemeHorizontalSlideAnimation] with specified horizontal slide settings.
  ///
  /// The [beginOffset] and [endOffset] parameters define the start and end positions for the slide animation.
  const PlayxThemeHorizontalSlideAnimation({
    this.beginOffset = const Offset(-1.0, 0.0),
    this.endOffset = const Offset(0.0, 0.0),
    super.isReversed,
    super.onAnimationFinish,
    super.duration,
  });

  @override
  Future<void> animate({required AnimationController controller}) async {
    Tween(begin: beginOffset, end: endOffset).animate(controller);
    if (isReversed) {
      await controller
          .reverse(from: 1.0)
          .then((value) => onAnimationFinish?.call());
    } else {
      await controller
          .forward(from: 0.0)
          .then((value) => onAnimationFinish?.call());
    }
  }
}

/// Defines a vertical slide animation effect with adjustable start and end offsets.
class PlayxThemeVerticalSlideAnimation extends PlayxThemeAnimation {
  /// An offset value that defines the start position of the vertical slide animation.
  final Offset beginOffset;

  /// An offset value that defines the end position of the vertical slide animation.
  final Offset endOffset;

  /// Creates a [PlayxThemeVerticalSlideAnimation] with specified vertical slide settings.
  ///
  /// The [beginOffset] and [endOffset] parameters define the start and end positions for the slide animation.
  const PlayxThemeVerticalSlideAnimation({
    this.beginOffset = const Offset(0.0, -1.0),
    this.endOffset = const Offset(0.0, 0.0),
    super.isReversed,
    super.onAnimationFinish,
    super.duration,
  });

  @override
  Future<void> animate({required AnimationController controller}) async {
    Tween(begin: beginOffset, end: endOffset).animate(controller);
    if (isReversed) {
      await controller
          .reverse(from: 1.0)
          .then((value) => onAnimationFinish?.call());
    } else {
      await controller
          .forward(from: 0.0)
          .then((value) => onAnimationFinish?.call());
    }
  }
}
