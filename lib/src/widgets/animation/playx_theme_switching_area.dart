import 'package:flutter/material.dart';
import 'package:playx_theme/src/controller/controller.dart';

import '../../../playx_theme.dart';

class PlayxThemeSwitchingArea extends StatelessWidget {
  const PlayxThemeSwitchingArea({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = XThemeController.instance;
    if (controller.oldTheme == null ||
        controller.oldTheme == controller.theme ||
        !(controller.controller?.isAnimating == true)) {
      // If there is no old theme, or no animation in progress, just show the current theme
      return Material(child: _getPage(controller.theme.themeData));
    } else {
      // Create the widgets for the transition
      late final Widget oldThemeWidget, newThemeWidget;
      if (controller.isReversed) {
        oldThemeWidget =
            _getPage(controller.theme.themeData); // Show the new theme first
        newThemeWidget =
            RawImage(image: controller.image); // Transition from screenshot
      } else {
        oldThemeWidget = RawImage(
            image: controller.image); // Show the old theme screenshot first
        newThemeWidget =
            _getPage(controller.theme.themeData); // Transition to the new theme
      }

      // Create a widget based on the selected animation type
      Widget transitionWidget;
      final animationType = controller.animationType;
      switch (animationType) {
        case PlayxThemeAnimationType.clipper:
          transitionWidget =
              _buildClipperAnimation(oldThemeWidget, newThemeWidget);
          break;
        case PlayxThemeAnimationType.fade:
          transitionWidget =
              _buildFadeAnimation(oldThemeWidget, newThemeWidget);
          break;
        case PlayxThemeAnimationType.scale:
          transitionWidget =
              _buildScaleAnimation(oldThemeWidget, newThemeWidget);
          break;
        case PlayxThemeAnimationType.horizontalSlide:
          transitionWidget =
              _buildHorizontalSlideAnimation(oldThemeWidget, newThemeWidget);
          break;
        case PlayxThemeAnimationType.verticalSlide:
          transitionWidget =
              _buildVerticalSlideAnimation(oldThemeWidget, newThemeWidget);
          break;
        default:
          transitionWidget =
              _buildClipperAnimation(oldThemeWidget, newThemeWidget);
      }

      return Material(child: transitionWidget);
    }
  }

  // Circular animation, similar to your original implementation
  Widget _buildClipperAnimation(Widget oldThemeWidget, Widget newThemeWidget) {
    final controller = XThemeController.instance;
    return Stack(
      children: [
        Container(
          key: const ValueKey('ThemeSwitchingAreaOldTheme'),
          child: oldThemeWidget,
        ),
        AnimatedBuilder(
          key: const ValueKey('ThemeSwitchingAreaNewTheme'),
          animation: controller.controller!,
          child: newThemeWidget,
          builder: (_, child) {
            return ClipPath(
              clipper: ThemeSwitcherClipperBridge(
                clipper: controller.clipper,
                offset: controller.switcherOffset,
                sizeRate: controller.controller?.value ?? 1,
              ),
              child: child,
            );
          },
        ),
      ],
    );
  }

  // Fade animation
  Widget _buildFadeAnimation(Widget oldThemeWidget, Widget newThemeWidget) {
    final controller = XThemeController.instance;
    return Stack(
      children: [
        FadeTransition(
          opacity: ReverseAnimation(controller.controller!),
          child: oldThemeWidget,
        ),
        FadeTransition(
          opacity: controller.controller!,
          child: newThemeWidget,
        ),
      ],
    );
  }

  // Scale animation
  Widget _buildScaleAnimation(Widget oldThemeWidget, Widget newThemeWidget) {
    final controller = XThemeController.instance;
    return Stack(
      children: [
        ScaleTransition(
          scale: ReverseAnimation(controller.controller!),
          child: oldThemeWidget,
        ),
        ScaleTransition(
          scale: controller.controller!,
          child: newThemeWidget,
        ),
      ],
    );
  }

  // Slide animation
  Widget _buildHorizontalSlideAnimation(
      Widget oldThemeWidget, Widget newThemeWidget) {
    final controller = XThemeController.instance;
    return Stack(
      children: [
        SlideTransition(
          position: controller.controller!.drive(Tween(
              begin: const Offset(0.0, 0.0), end: const Offset(1.0, 0.0))),
          child: oldThemeWidget,
        ),
        SlideTransition(
          position: controller.controller!.drive(Tween(
              begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))),
          child: newThemeWidget,
        ),
      ],
    );
  }

  Widget _buildVerticalSlideAnimation(
      Widget oldThemeWidget, Widget newThemeWidget) {
    final controller = XThemeController.instance;
    return Stack(
      children: [
        SlideTransition(
          position: controller.controller!.drive(Tween(
              begin: const Offset(0.0, 0.0), end: const Offset(0.0, 1.0))),
          child: oldThemeWidget,
        ),
        SlideTransition(
          position: controller.controller!.drive(Tween(
              begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0))),
          child: newThemeWidget,
        ),
      ],
    );
  }

  Widget _getPage(ThemeData brandTheme) {
    return Theme(
      key: const ValueKey('ThemeSwitchingAreaPage'),
      data: brandTheme,
      child: child,
    );
  }
}

class ThemeSwitcherClipperBridge extends CustomClipper<Path> {
  ThemeSwitcherClipperBridge(
      {required this.sizeRate, required this.offset, required this.clipper});

  final double sizeRate;
  final Offset offset;
  final ThemeSwitcherClipper clipper;

  @override
  Path getClip(Size size) {
    return clipper.getClip(size, offset, sizeRate);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return clipper.shouldReclip(oldClipper, offset, sizeRate);
  }
}
