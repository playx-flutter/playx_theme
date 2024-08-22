import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  group('PlayxColors', () {
    test('Default constructor initializes with default values', () {
      const colors = PlayxColors();

      expect(colors.primary, PlayxColors.blueMain);
      expect(colors.onPrimary, PlayxColors.white);
      expect(colors.primaryContainer, PlayxColors.white);
      expect(colors.onPrimaryContainer, PlayxColors.black);
      expect(colors.secondary, Colors.teal);
      expect(colors.onSecondary, PlayxColors.white);
      expect(colors.secondaryContainer, PlayxColors.white);
      expect(colors.onSecondaryContainer, PlayxColors.black);
      expect(colors.tertiary, PlayxColors.purpleMain);
      expect(colors.onTertiary, PlayxColors.white);
      expect(colors.error, PlayxColors.red);
      expect(colors.onError, PlayxColors.white);
      expect(colors.errorContainer, PlayxColors.redLight);
      expect(colors.onErrorContainer, PlayxColors.white);
      expect(colors.outline, PlayxColors.black);
      expect(colors.outlineVariant, Colors.black12);
      expect(colors.surface, PlayxColors.white);
      expect(colors.onSurface, PlayxColors.black);
      expect(colors.inverseSurface, PlayxColors.black);
      expect(colors.onInverseSurface, PlayxColors.white);
      expect(colors.inversePrimary, PlayxColors.white);
      expect(colors.shadow, PlayxColors.black);
      expect(colors.scrim, PlayxColors.white);
      expect(colors.surfaceTint, PlayxColors.white);
    });

    test('Custom constructor initializes with provided values', () {
      const customPrimary = Colors.red;
      const customOnPrimary = Colors.white;
      const colors =
          PlayxColors(primary: customPrimary, onPrimary: customOnPrimary);

      expect(colors.primary, customPrimary);
      expect(colors.onPrimary, customOnPrimary);
    });

    test('fromColorScheme constructor correctly overrides values', () {
      const colorScheme = ColorScheme.light(
        primary: Colors.purple,
        onPrimary: Colors.orange,
      );

      final colors = PlayxColors.fromColorScheme(scheme: colorScheme);

      expect(colors.primary, Colors.purple);
      expect(colors.onPrimary, Colors.orange);
    });

    testWidgets('of method retrieves the correct PlayxColors from context',
        (WidgetTester tester) async {
      const playxColors = PlayxColors(primary: Colors.red);

      final theme = XTheme(
        id: 'test-theme',
        name: 'Test Theme',
        themeData: ThemeData(),
        colors: playxColors,
      );

      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();

      await PlayxTheme.boot(
          config: PlayxThemeConfig(
        themes: [theme],
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: PlayxThemeBuilder(
            child: Builder(
              builder: (context) {
                final retrievedColors = PlayxColors.of(context);
                expect(retrievedColors.primary, playxColors.primary);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });

    testWidgets(
        'maybeOf method retrieves the correct PlayxColors from context or null',
        (WidgetTester tester) async {
      const playxColors = PlayxColors(primary: Colors.red);

      final theme = XTheme(
        id: 'test-theme',
        name: 'Test Theme',
        themeData: ThemeData(),
        colors: playxColors,
      );

      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();

      await PlayxTheme.boot(
          config: PlayxThemeConfig(
        themes: [theme],
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: PlayxThemeBuilder(
            child: Builder(
              builder: (context) {
                final retrievedColors = PlayxColors.maybeOf(context);
                expect(retrievedColors?.primary, playxColors.primary);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Test when no PlayxColors is available in the context
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            final retrievedColors = PlayxColors.maybeOf(context);
            expect(retrievedColors, isNull);
            return const SizedBox.shrink();
          },
        ),
      ));
    });
  });
}
