import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart'; // Adjust import as needed

void main() {
  group('XTheme', () {
    test('XTheme constructor should create correct instance', () {
      final themeData = ThemeData.light();
      const cupertinoThemeData = CupertinoThemeData();
      const colors = PlayxColors();

      final xTheme = XTheme(
        id: 'theme1',
        name: 'Light Theme',
        themeData: themeData,
        cupertinoThemeData: cupertinoThemeData,
        colors: colors,
        isDark: false,
      );

      expect(xTheme.id, 'theme1');
      expect(xTheme.name, 'Light Theme');
      expect(xTheme.themeData, themeData);
      expect(xTheme.cupertinoThemeData, cupertinoThemeData);
      expect(xTheme.colors, colors);
      expect(xTheme.isDark, false);
    });

    test('XTheme.builder should create correct instance', () {
      final initialTheme = ThemeData.light();

      final xTheme = XTheme.builder(
        id: 'theme2',
        name: 'Dynamic Theme',
        initialTheme: initialTheme,
        themeBuilder: (locale) => ThemeData.dark(),
        cupertinoThemeBuilder: (locale) => const CupertinoThemeData(),
      );

      expect(xTheme.id, 'theme2');
      expect(xTheme.name, 'Dynamic Theme');
      expect(xTheme.themeData, initialTheme);
      expect(xTheme.themeBuilder!(null), isInstanceOf<ThemeData>());
      expect(xTheme.cupertinoThemeBuilder!(null),
          isInstanceOf<CupertinoThemeData>());
    });

    test('XTheme equality and props and toString()', () {
      final xTheme1 = XTheme(
        id: 'theme1',
        name: 'Light Theme',
        themeData: ThemeData.light(),
      );

      final xTheme2 = XTheme(
        id: 'theme1',
        name: 'Light Theme',
        themeData: ThemeData.light(),
      );

      final xTheme3 = XTheme(
        id: 'theme2',
        name: 'Dark Theme',
        themeData: ThemeData.dark(),
      );

      expect(xTheme1 == xTheme2, isTrue); // Same id and name, should be equal
      expect(xTheme1 == xTheme3,
          isFalse); // Different id and name, should not be equal
      expect(xTheme1.props, [xTheme1.id, xTheme1.name]);

      expect(xTheme1.toString(), 'XTheme(id: theme1, name: Light Theme)');
      expect(xTheme3.toString(), 'XTheme(id: theme2, name: Dark Theme)');
    });

    testWidgets('XTheme.of should return current theme from context',
        (WidgetTester tester) async {
      final xTheme = XTheme(
        id: 'theme1',
        name: 'Light Theme',
        themeData: ThemeData.light(),
      );
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();

      await PlayxTheme.boot(
          config: PlayxThemeConfig(
        themes: [xTheme],
      ));

      await tester.pumpWidget(
        PlayxThemeBuilder(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final retrievedTheme = XTheme.of(context);
                expect(retrievedTheme, xTheme);
                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets(
        'XTheme.maybeOf should return current theme or null from context',
        (WidgetTester tester) async {
      final xTheme = XTheme(
        id: 'theme1',
        name: 'Light Theme',
        themeData: ThemeData.light(),
      );
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();

      await PlayxTheme.boot(
          config: PlayxThemeConfig(
        themes: [xTheme],
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: PlayxThemeBuilder(
            child: Builder(
              builder: (context) {
                final retrievedTheme = XTheme.maybeOf(context);
                expect(retrievedTheme, xTheme);
                return Container();
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final retrievedTheme = XTheme.maybeOf(context);
              expect(retrievedTheme,
                  isNull); // No PlayxInheritedTheme in the context
              return Container();
            },
          ),
        ),
      );
    });
  });
}
