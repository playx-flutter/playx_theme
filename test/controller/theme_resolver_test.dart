import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/theme_resolver.dart';

import '../config/config.dart';

PlayxThemeConfig _c({
  int? index,
  ThemeMode? mode,
  int? light,
  int? dark,
  List<XTheme>? themes,
}) => PlayxThemeConfig(
  initialThemeIndex: index,
  initialThemeMode: mode,
  lightThemeIndex: light,
  darkThemeIndex: dark,
  themes: themes ?? [lightTestTheme, darkTestTheme],
);

void main() {
  group('themeForBrightness', () {
    test('picks the first matching theme', () {
      expect(ThemeResolver.themeForBrightness(_c(), false)?.id, 'Light');
      expect(ThemeResolver.themeForBrightness(_c(), true)?.id, 'Dark');
    });
    test('uses configured indices', () {
      final extra = XTheme(
        id: 'D2',
        name: 'D2',
        themeData: ThemeData.dark(),
        isDark: true,
      );
      final themes = [lightTestTheme, darkTestTheme, extra];
      expect(
        ThemeResolver.themeForBrightness(_c(themes: themes, dark: 2), true)?.id,
        'D2',
      );
    });
    test('returns null when nothing matches', () {
      expect(
        ThemeResolver.themeForBrightness(_c(themes: [lightTestTheme]), true),
        isNull,
      );
    });
  });

  group('initialMode / initialTheme', () {
    test('index wins over mode', () {
      expect(
        ThemeResolver.initialMode(_c(index: 1, mode: ThemeMode.light)),
        ThemeMode.dark,
      );
      expect(
        ThemeResolver.initialTheme(_c(index: 1), deviceIsDark: false).id,
        'Dark',
      );
    });
    test('mode, then system default', () {
      expect(
        ThemeResolver.initialMode(_c(mode: ThemeMode.dark)),
        ThemeMode.dark,
      );
      expect(ThemeResolver.initialMode(_c()), ThemeMode.system);
      expect(ThemeResolver.initialTheme(_c(), deviceIsDark: true).id, 'Dark');
      expect(
        ThemeResolver.initialTheme(
          _c(mode: ThemeMode.light),
          deviceIsDark: true,
        ).id,
        'Light',
      );
    });
    test('falls back to the first theme', () {
      expect(
        ThemeResolver.initialTheme(
          _c(mode: ThemeMode.dark, themes: [lightTestTheme]),
          deviceIsDark: false,
        ).id,
        'Light',
      );
    });
  });

  group('resolveBoot', () {
    ResolvedTheme r({
      int? i,
      String? m,
      bool dark = false,
      PlayxThemeConfig? c,
    }) => ThemeResolver.resolveBoot(
      c ?? _c(index: 0),
      savedIndex: i,
      savedMode: m,
      deviceIsDark: dark,
    );

    test('nothing saved uses the initial theme and mode', () {
      expect(r().theme.id, 'Light');
      expect(r().mode, ThemeMode.light);
    });
    test('index only derives the mode from the theme', () {
      expect(r(i: 1).theme.id, 'Dark');
      expect(r(i: 1).mode, ThemeMode.dark);
    });
    test('saved mode + index', () {
      expect(r(i: 1, m: 'dark').theme.id, 'Dark');
    });
    test('saved system mode follows the device', () {
      expect(r(i: 0, m: 'system', dark: true).theme.id, 'Dark');
      expect(r(i: 0, m: 'system').mode, ThemeMode.system);
    });
    test('saved mode with an invalid index picks by mode', () {
      expect(r(i: 9, m: 'dark').theme.id, 'Dark');
      expect(r(m: 'light').theme.id, 'Light');
    });
    test('unknown mode falls back to system', () {
      expect(r(m: 'bogus').mode, ThemeMode.system);
    });
    test('out-of-range index is ignored', () {
      expect(r(i: -1).theme.id, 'Light');
      expect(r(i: 5).theme.id, 'Light');
    });
  });
}
