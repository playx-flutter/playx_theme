import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/src/utils/animation_utils.dart';

void main() {
  testWidgets('saveScreenshot captures an image', (WidgetTester tester) async {
    // Create a global key to pass to the saveScreenshot method
    final GlobalKey previewContainer = GlobalKey();

    // Build a widget with the RepaintBoundary and attach it to the key
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RepaintBoundary(
            key: previewContainer,
            child: Container(width: 100, height: 100, color: Colors.red),
          ),
        ),
      ),
    );

    // Wait for the widget tree to settle
    await tester.pumpAndSettle();

    // Capture the screenshot
    final ui.Image screenshot = await AnimationUtils.saveScreenshot(
      previewContainer: previewContainer,
    );

    // Verify the screenshot dimensions
    expect(screenshot, isNotNull);
    expect(screenshot.width, greaterThan(0));
    expect(screenshot.height, greaterThan(0));
  });

  testWidgets('getSwitcherCoordinates with valid context',
      (WidgetTester tester) async {
    // Build a simple widget to obtain a context
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(width: 100, height: 100, color: Colors.red),
        ),
      ),
    );

    final BuildContext context = tester.element(find.byType(Container));
    final Offset coordinates = AnimationUtils.getSwitcherCoordinates(context);

    // Validate coordinates are near the center of the Container
    expect(coordinates.dx, closeTo(50, 1));
    expect(coordinates.dy, closeTo(50, 1));
  });

  test('getSwitcherCoordinates with null context and offset', () {
    final Offset tapOffset = Offset(25, 25);
    final Offset coordinates =
        AnimationUtils.getSwitcherCoordinates(null, tapOffset);

    // Validate coordinates match the provided tap offset
    expect(coordinates, tapOffset);
  });

  test('getCurrentView returns a view', () {
    final ui.FlutterView? view = AnimationUtils.getCurrentView();

    // Check if view is not null and has a positive pixel ratio
    expect(view, isNotNull);
    expect(view?.devicePixelRatio, greaterThan(0));
  });

  test('getCenterOffset returns center of the screen', () {
    final Offset centerOffset = AnimationUtils.getCenterOffset();

    // Check if the center offset is a valid positive offset
    expect(centerOffset.dx, greaterThan(0));
    expect(centerOffset.dy, greaterThan(0));
  });
}
