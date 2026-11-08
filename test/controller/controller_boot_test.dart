import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';

import '../config/config.dart';

const _indexKey = XThemeController.lastKnownIndexKey;
const _modeKey = XThemeController.lastKnownThemeModeKey;

PlayxThemeConfig _config({
  int? initialThemeIndex,
  ThemeMode? initialThemeMode,
  int? lightThemeIndex,
  int? darkThemeIndex,
  PlayxThemeStorage? storage,
  bool saveTheme = true,
  List<XTheme>? themes,
}) => PlayxThemeConfig(
  initialThemeIndex: initialThemeIndex,
  initialThemeMode: initialThemeMode,
  lightThemeIndex: lightThemeIndex,
  darkThemeIndex: darkThemeIndex,
  themes: themes ?? [lightTestTheme, darkTestTheme],
  storage: storage,
  saveTheme: saveTheme,
);

Future<XThemeController> _boot(PlayxThemeConfig config) async {
  final controller = XThemeController(config: config);
  await controller.boot();
  return controller;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('initial theme resolution', () {
    test('initialThemeIndex wins and derives the mode from the theme', () {
      final c = XThemeController(config: _config(initialThemeIndex: 1));
      expect(c.getInitialTheme().id, 'Dark');
      expect(c.getInitialThemeMode(), ThemeMode.dark);
      c.dispose();
    });

    test('initialThemeMode light/dark/system pick matching themes', () {
      expect(
        XThemeController.getInitialThemeByConfig(
          _config(initialThemeMode: ThemeMode.light),
        ).id,
        'Light',
      );
      expect(
        XThemeController.getInitialThemeByConfig(
          _config(initialThemeMode: ThemeMode.dark),
        ).id,
        'Dark',
      );
      // Test device is in light mode.
      expect(
        XThemeController.getInitialThemeByConfig(
          _config(initialThemeMode: ThemeMode.system),
        ).id,
        'Light',
      );
    });

    test('falls back to the device mode and ThemeMode.system by default', () {
      final config = _config();
      expect(XThemeController.getInitialThemeByConfig(config).id, 'Light');
      final c = XThemeController(config: config);
      expect(c.getInitialThemeMode(), ThemeMode.system);
      c.dispose();
    });

    test('falls back to the first theme when there is no matching theme', () {
      final config = _config(
        initialThemeMode: ThemeMode.dark,
        themes: [lightTestTheme],
      );
      expect(XThemeController.getInitialThemeByConfig(config).id, 'Light');
    });

    test('lightThemeIndex / darkThemeIndex are respected', () {
      final extraDark = XTheme(
        id: 'Dark2',
        name: 'Dark2',
        themeData: ThemeData.dark(),
        isDark: true,
      );
      final config = _config(
        themes: [lightTestTheme, darkTestTheme, extraDark],
        darkThemeIndex: 2,
        initialThemeMode: ThemeMode.dark,
      );
      expect(XThemeController.getInitialThemeByConfig(config).id, 'Dark2');
    });
  });

  group('boot with saved state', () {
    test('restores a saved mode + index', () async {
      final c = await _boot(
        _config(
          storage: PlayxMemoryThemeStorage({_modeKey: 'dark', _indexKey: 1}),
        ),
      );
      expect(c.value.id, 'Dark');
      expect(c.themeMode, ThemeMode.dark);
      c.dispose();
    });

    test('saved system mode follows the device theme', () async {
      final c = await _boot(
        _config(
          storage: PlayxMemoryThemeStorage({_modeKey: 'system', _indexKey: 1}),
        ),
      );
      expect(c.themeMode, ThemeMode.system);
      expect(c.value.id, 'Light');
      c.dispose();
    });

    test('saved mode without a valid index picks the theme by mode', () async {
      final c = await _boot(
        _config(
          storage: PlayxMemoryThemeStorage({_modeKey: 'dark', _indexKey: 42}),
        ),
      );
      expect(c.value.id, 'Dark');
      c.dispose();
      final l = await _boot(
        _config(storage: PlayxMemoryThemeStorage({_modeKey: 'light'})),
      );
      expect(l.value.id, 'Light');
      l.dispose();
    });

    test('an unknown saved mode falls back to system', () async {
      final c = await _boot(
        _config(storage: PlayxMemoryThemeStorage({_modeKey: 'bogus'})),
      );
      expect(c.themeMode, ThemeMode.system);
      c.dispose();
    });

    test(
      'only an index saved (v1 upgrade) restores that theme and mode',
      () async {
        final c = await _boot(
          _config(
            initialThemeIndex: 0,
            storage: PlayxMemoryThemeStorage({_indexKey: 1}),
          ),
        );
        expect(c.value.id, 'Dark');
        expect(c.themeMode, ThemeMode.dark);
        expect(c.currentIndex, 1);
        c.dispose();
      },
    );

    test('ignores saved state when saveTheme is false', () async {
      final c = await _boot(
        _config(
          saveTheme: false,
          initialThemeIndex: 0,
          storage: PlayxMemoryThemeStorage({_modeKey: 'dark', _indexKey: 1}),
        ),
      );
      expect(c.value.id, 'Light');
      c.dispose();
    });
  });

  group('platform brightness', () {
    testWidgets('follows the device theme while in system mode', (
      tester,
    ) async {
      final c = await _boot(
        _config(saveTheme: false, initialThemeMode: ThemeMode.system),
      );
      expect(c.value.id, 'Light');

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      await tester.pump();
      expect(c.value.id, 'Dark');
      expect(c.themeMode, ThemeMode.system);

      tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
      await tester.pump();
      expect(c.value.id, 'Light');

      tester.platformDispatcher.clearPlatformBrightnessTestValue();
      c.dispose();
    });

    testWidgets('is ignored when a fixed mode is selected', (tester) async {
      final c = await _boot(
        _config(saveTheme: false, initialThemeMode: ThemeMode.light),
      );
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      await tester.pump();
      expect(c.value.id, 'Light');
      tester.platformDispatcher.clearPlatformBrightnessTestValue();
      c.dispose();
    });
  });

  group('misc', () {
    test('instance throws before boot', () {
      expect(() => XThemeController.instance, throwsException);
    });

    test('nextThemeIndex wraps around', () async {
      final c = await _boot(_config(saveTheme: false, initialThemeIndex: 1));
      expect(c.nextThemeIndex, 0);
      expect(c.nextThemeValue.id, 'Light');
      c.dispose();
    });

    test('legacy PlayxPrefs index is migrated when requested', () async {
      PlayxPrefs.setMockInitialValues({_indexKey: 1});
      final storage = PlayxMemoryThemeStorage();
      final c = XThemeController(
        config: PlayxThemeConfig(
          themes: [lightTestTheme, darkTestTheme],
          migratePrefsToAsyncPrefs: true,
          storage: storage,
        ),
      );
      expect(await c.getLastSavedIndexFromPrefs(migratePrefsToAsync: true), 1);
      expect(await storage.getInt(_indexKey), 1);
      c.dispose();
    });

    testWidgets('forceUpdateTheme reassembles the app', (tester) async {
      final c = await _boot(_config(saveTheme: false));
      await tester.pumpWidget(const SizedBox());
      c.forceUpdateTheme();
      await tester.pump();
      c.dispose();
    });

    test('dispose is idempotent', () async {
      final c = await _boot(_config(saveTheme: false));
      c.dispose();
      expect(c.dispose, returnsNormally);
    });
  });
}
