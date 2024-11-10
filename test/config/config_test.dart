import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/src/config/config.dart';
import 'package:playx_theme/src/model/playx_colors.dart';
import 'package:playx_theme/src/model/x_theme.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Test Playx Theme Config', () {
    test('PlayxThemeConfig initializes with valid values', () {
      final theme1 = XTheme(
        id: 'light',
        name: 'Light',
        themeData: ThemeData.light(),
        cupertinoThemeData: CupertinoThemeData(brightness: Brightness.light),
        isDark: false,
        colors: const PlayxColors(),
      );

      final theme2 = XTheme(
        id: 'dark',
        name: 'Dark',
        themeData: ThemeData.dark(),
        cupertinoThemeData: CupertinoThemeData(brightness: Brightness.dark),
        isDark: true,
        colors: const PlayxColors(),
      );

      final config = PlayxThemeConfig(
        initialThemeIndex: 0,
        saveTheme: true,
        themes: [theme1, theme2],
        migratePrefsToAsyncPrefs: true,
      );

      expect(config.initialThemeIndex, 0);
      expect(config.saveTheme, true);
      expect(config.themes.length, 2);
      expect(config.themes[0].name, 'Light');
      expect(config.themes[1].isDark, true);
      expect(config.migratePrefsToAsyncPrefs, true);
    });

    test('PlayxThemeConfig throws assertion error if themes list is empty', () {
      expect(
        () => PlayxThemeConfig(
          initialThemeIndex: 0,
          themes: [],
        ),
        throwsAssertionError,
      );
    });
  });
  test(
      'PlayxThemeConfig throws assertion error if initialThemeIndex is out of range',
      () {
    final theme1 = XTheme(
      id: 'light',
      name: 'Light',
      themeData: ThemeData.light(),
      cupertinoThemeData: CupertinoThemeData(brightness: Brightness.light),
      isDark: false,
      colors: const PlayxColors(),
    );

    expect(
      () => PlayxThemeConfig(
        initialThemeIndex: 1, // Out of range for a single theme in the list
        themes: [theme1],
      ),
      throwsAssertionError,
    );
  });

  group('XDefaultThemeConfig Tests', () {
    test('XDefaultThemeConfig initializes with default light and dark themes',
        () {
      final config = XDefaultThemeConfig();

      expect(config.themes.length, 2);
      expect(config.themes[0].id, 'light');
      expect(config.themes[1].id, 'dark');
      expect(config.themes[0].themeData.brightness, Brightness.light);
      expect(config.themes[1].themeData.brightness, Brightness.dark);
      expect(config.initialThemeIndex,
          anyOf(0, 1)); // Should be 0 or 1 depending on device mode
    });
  });
}
