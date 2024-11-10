import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AnimationUtils {
  static Future<ui.Image> saveScreenshot({
    required GlobalKey previewContainer,
  }) async {
    final boundary = previewContainer.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    return boundary.toImage(
        pixelRatio: getCurrentView()?.devicePixelRatio ?? 1);
  }

  static Offset getSwitcherCoordinates(BuildContext? context,
      [Offset? tapOffset]) {
    if (context == null) {
      return tapOffset ?? getCenterOffset();
    }
    final renderObject = context.findRenderObject() as RenderBox?;
    if (renderObject == null) {
      return tapOffset ?? getCenterOffset();
    }
    final size = renderObject.size;
    return renderObject.localToGlobal(Offset.zero).translate(
          tapOffset?.dx ?? (size.width / 2),
          tapOffset?.dy ?? (size.height / 2),
        );
  }

  static ui.FlutterView? getCurrentView() {
    return WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
  }

  static Offset getCenterOffset() {
    final view = getCurrentView();
    if (view == null) {
      return Offset.zero;
    }
    final Size windowSize = view.physicalSize / view.devicePixelRatio;
    return Offset(windowSize.width / 2, windowSize.height / 2);
  }
}
