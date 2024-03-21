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
    final controller = Get.find<XThemeController>();
    Widget child;
    if (controller.oldTheme == null ||
        controller.oldTheme == controller.theme ||
        !(controller.controller?.isAnimating == true)) {
      child = _getPage(controller.theme.themeData);
    } else {
      late final Widget firstWidget, animWidget;
      if (controller.isReversed) {
        firstWidget = _getPage(controller.theme.themeData);
        animWidget = RawImage(image: controller.image);
      } else {
        firstWidget = RawImage(image: controller.image);
        animWidget = _getPage(controller.theme.themeData);
      }
      child = Stack(
        children: [
          Container(
            key: const ValueKey('ThemeSwitchingAreaFirstChild'),
            child: firstWidget,
          ),
          AnimatedBuilder(
            key: const ValueKey('ThemeSwitchingAreaSecondChild'),
            animation: controller.controller!,
            child: animWidget,
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

    return Material(child: child);
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
