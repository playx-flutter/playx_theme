import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';

import '../config/config.dart';

Future<void> _pumpArea(WidgetTester tester) async {
  await tester.pumpWidget(
    PlayxThemeBuilder(
      builder: (context, xTheme) => MaterialApp(
        theme: xTheme.themeData,
        home: PlayxThemeSwitchingArea(
          child: Text('theme ${xTheme.id}', textDirection: TextDirection.ltr),
        ),
      ),
    ),
  );
}

void main() {
  setUp(() async {
    await PlayxTheme.boot(
      config: PlayxThemeConfig(
        saveTheme: false,
        initialThemeIndex: 0,
        themes: [lightTestTheme, darkTestTheme],
      ),
    );
  });
  tearDown(() => PlayxTheme.dispose());

  testWidgets('shows the child when no animation is running', (tester) async {
    await _pumpArea(tester);
    expect(find.text('theme Light'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('ThemeSwitchingAreaPage')),
      findsOneWidget,
    );
  });

  final animations = <String, PlayxThemeAnimation>{
    'clipper': PlayxThemeAnimation.clipper(),
    'fade': const PlayxThemeAnimation.fade(),
    'scale': const PlayxThemeAnimation.scale(),
    'horizontalSlide': const PlayxThemeAnimation.horizontalSlide(),
    'verticalSlide': const PlayxThemeAnimation.verticalSlide(),
    'lerp': const PlayxThemeAnimation.lerp(),
  };

  for (final reversed in [false, true]) {
    for (final entry in animations.entries) {
      testWidgets(
        '${entry.key} transition renders while animating (reversed: $reversed)',
        (tester) async {
          await _pumpArea(tester);
          final controller = XThemeController.instance;

          // Simulate what `animateTheme` does without taking a screenshot.
          final base = entry.value;
          controller.oldTheme = lightTestTheme;
          controller.themeAnimation = reversed
              ? switch (base) {
                  PlayxThemeClipperAnimation() => PlayxThemeAnimation.clipper(
                    isReversed: true,
                  ),
                  PlayxThemeFadeAnimation() => base,
                  PlayxThemeScaleAnimation() => const PlayxThemeAnimation.scale(
                    isReversed: true,
                  ),
                  PlayxThemeHorizontalSlideAnimation() =>
                    const PlayxThemeAnimation.horizontalSlide(isReversed: true),
                  PlayxThemeVerticalSlideAnimation() =>
                    const PlayxThemeAnimation.verticalSlide(isReversed: true),
                  PlayxThemeLerpAnimation() => base,
                }
              : base;
          controller.value = darkTestTheme;
          controller.controller!.duration = const Duration(milliseconds: 300);
          controller.controller!.forward(from: 0);

          await tester.pump(const Duration(milliseconds: 150));
          expect(tester.takeException(), isNull);
          expect(find.byType(PlayxThemeSwitchingArea), findsOneWidget);
          expect(find.text('theme Dark'), findsWidgets);

          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('PlayxThemeSwitcher builds with the current theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PlayxThemeSwitcher(
          builder: (context, theme) =>
              Text(theme.id, textDirection: TextDirection.ltr),
        ),
      ),
    );
    expect(find.text('Light'), findsOneWidget);
  });
}
