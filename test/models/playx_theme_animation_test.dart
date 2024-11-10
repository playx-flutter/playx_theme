import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';

void main() {
  group('PlayxThemeAnimation Tests', () {
    testWidgets('PlayxThemeClipperAnimation animates correctly',
        (WidgetTester tester) async {
      bool animationFinished = false;
      late AnimationController controller;
      final animation = PlayxThemeClipperAnimation(
        onAnimationFinish: () => animationFinished = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                controller = AnimationController(
                  vsync: tester,
                  duration: animation.duration,
                );

                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return controller.value > 0.5
                        ? Container()
                        : const Placeholder();
                  },
                );
              },
            ),
          ),
        ),
      );

      animation.animate(controller: controller);
      await tester.pumpAndSettle();

      expect(animationFinished, isTrue);
      expect(controller.value, 1.0);
      expect(animation.duration, controller.duration);
      expect(animation.isReversed, false);
    });

    testWidgets(
        'PlayxThemeClipperAnimation with isReversed true animates correctly',
        (WidgetTester tester) async {
      bool animationFinished = false;
      late AnimationController controller;
      final animation = PlayxThemeClipperAnimation(
        isReversed: true,
        onAnimationFinish: () => animationFinished = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                controller = AnimationController(
                  vsync: tester,
                  duration: animation.duration,
                );

                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return controller.value > 0.5
                        ? Container()
                        : const Placeholder();
                  },
                );
              },
            ),
          ),
        ),
      );

      animation.animate(controller: controller);
      await tester.pumpAndSettle();

      expect(animationFinished, isTrue);
      expect(controller.value, 0.0);
      expect(animation.duration, controller.duration);
      expect(animation.isReversed, true);
    });

    testWidgets('PlayxThemeFadeAnimation fades from begin to end',
        (WidgetTester tester) async {
      bool animationFinished = false;
      late AnimationController controller;
      final animation = PlayxThemeFadeAnimation(
        begin: 0.0,
        end: 1.0,
        onAnimationFinish: () => animationFinished = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                controller = AnimationController(
                  vsync: tester,
                  duration: animation.duration,
                );

                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Opacity(
                        opacity: controller.value,
                        child: const Text('Fade Test'));
                  },
                );
              },
            ),
          ),
        ),
      );

      animation.animate(controller: controller);
      await tester.pumpAndSettle();

      expect(animationFinished, isTrue);
      expect(controller.value, 1.0);
      expect(animation.begin, 0.0);
      expect(animation.end, 1.0);
    });

    testWidgets('PlayxThemeScaleAnimation scales correctly from begin to end',
        (WidgetTester tester) async {
      bool animationFinished = false;
      late AnimationController controller;
      final animation = PlayxThemeScaleAnimation(
        begin: 0.5,
        end: 1.0,
        onAnimationFinish: () => animationFinished = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                controller = AnimationController(
                  vsync: tester,
                  duration: animation.duration,
                );

                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform.scale(
                        scale: controller.value,
                        child: const Text('Scale Test'));
                  },
                );
              },
            ),
          ),
        ),
      );

      animation.animate(controller: controller);
      await tester.pumpAndSettle();

      expect(animationFinished, isTrue);
      expect(controller.value, 1.0);
      expect(animation.begin, 0.5);
      expect(animation.end, 1.0);
    });

    testWidgets(
        'PlayxThemeScaleAnimation scales correctly from end to begin when isReversed is true',
        (WidgetTester tester) async {
      bool animationFinished = false;
      late AnimationController controller;
      final animation = PlayxThemeScaleAnimation(
        begin: 1.0,
        end: 0.5,
        isReversed: true,
        onAnimationFinish: () => animationFinished = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                controller = AnimationController(
                  vsync: tester,
                  duration: animation.duration,
                );

                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform.scale(
                        scale: controller.value,
                        child: const Text('Scale Test'));
                  },
                );
              },
            ),
          ),
        ),
      );

      animation.animate(controller: controller);
      await tester.pumpAndSettle();

      expect(animationFinished, isTrue);
      expect(controller.value, 0.0);
      expect(animation.begin, 1.0);
      expect(animation.end, 0.5);
    });

    testWidgets(
        'PlayxThemeHorizontalSlideAnimation slides horizontally as expected',
        (WidgetTester tester) async {
      bool animationFinished = false;
      late AnimationController controller;
      final animation = PlayxThemeHorizontalSlideAnimation(
        beginOffset: const Offset(-1.0, 0.0),
        endOffset: const Offset(0.0, 0.0),
        onAnimationFinish: () => animationFinished = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                controller = AnimationController(
                  vsync: tester,
                  duration: animation.duration,
                );

                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(controller.value * 100, 0),
                      child: const Text('Horizontal Slide Test'),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      animation.animate(controller: controller);
      await tester.pumpAndSettle();

      expect(animationFinished, isTrue);
      expect(controller.value, 1.0);
      expect(animation.beginOffset, const Offset(-1.0, 0.0));
      expect(animation.endOffset, const Offset(0.0, 0.0));
    });

    testWidgets(
        'PlayxThemeVerticalSlideAnimation slides vertically as expected',
        (WidgetTester tester) async {
      bool animationFinished = false;
      late AnimationController controller;
      final animation = PlayxThemeVerticalSlideAnimation(
        beginOffset: const Offset(0.0, -1.0),
        endOffset: const Offset(0.0, 0.0),
        onAnimationFinish: () => animationFinished = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                controller = AnimationController(
                  vsync: tester,
                  duration: animation.duration,
                );

                return AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, controller.value * 100),
                      child: const Text('Vertical Slide Test'),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      animation.animate(controller: controller);
      await tester.pumpAndSettle();

      expect(animationFinished, isTrue);
      expect(controller.value, 1.0);
      expect(animation.beginOffset, const Offset(0.0, -1.0));
      expect(animation.endOffset, const Offset(0.0, 0.0));
    });
  });
}
