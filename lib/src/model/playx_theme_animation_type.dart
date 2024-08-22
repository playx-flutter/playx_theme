import 'package:flutter/animation.dart';

enum PlayxThemeAnimationType {
  clipper,
  fade,
  scale,
  horizontalSlide,
  verticalSlide;

  Future<void> animate(
      {required AnimationController controller,
      required bool isReversed,
      VoidCallback? onAnimationFinish}) async {
    switch (this) {
      case clipper:
        await _animateClipper(
            controller: controller,
            isReversed: isReversed,
            onAnimationFinish: onAnimationFinish);
        break;
      case fade:
        await _animateFade(
            controller: controller,
            isReversed: isReversed,
            onAnimationFinish: onAnimationFinish);
        break;
      case scale:
        await _animateScale(
            controller: controller,
            isReversed: isReversed,
            onAnimationFinish: onAnimationFinish);
        break;
      case horizontalSlide:
        await _animateHorizontalSlide(
            controller: controller,
            isReversed: isReversed,
            onAnimationFinish: onAnimationFinish);
        break;
      case verticalSlide:
        await _animateVerticalSlide(
            controller: controller,
            isReversed: isReversed,
            onAnimationFinish: onAnimationFinish);
        break;
    }
  }

  /// Circular animation
  Future<void> _animateClipper(
      {required AnimationController controller,
      required bool isReversed,
      VoidCallback? onAnimationFinish}) async {
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

  /// Fade animation
  Future<void> _animateFade(
      {required AnimationController controller,
      required bool isReversed,
      VoidCallback? onAnimationFinish}) async {
    Tween(begin: 0.0, end: 1.0).animate(controller);
    await controller
        .forward(from: 0.0)
        .then((value) => onAnimationFinish?.call());
  }

  /// Scale animation
  Future<void> _animateScale(
      {required AnimationController controller,
      required bool isReversed,
      VoidCallback? onAnimationFinish}) async {
    Tween(begin: 0.5, end: 1.0).animate(controller);
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

  /// Slide animation
  Future<void> _animateHorizontalSlide(
      {required AnimationController controller,
      required bool isReversed,
      VoidCallback? onAnimationFinish}) async {
    // Slide animation logic
    Tween(begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(controller);
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

  Future<void> _animateVerticalSlide(
      {required AnimationController controller,
      required bool isReversed,
      VoidCallback? onAnimationFinish}) async {
    // Slide animation logic
    Tween(begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0))
        .animate(controller);
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
