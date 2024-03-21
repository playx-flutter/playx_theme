import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';

import '../config/config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  late XThemeController controller;

  setUp(() async {
    PlayxPrefs.setMockInitialValues({});
    await PlayxCore.bootCore();
    controller = XThemeController(config: getTestConfig());
    await controller.boot();
  });
  tearDown(() async {
    await PlayxPrefs.clear();
    await PlayxCore.dispose();
    // await PlayxTheme.dispose();
  });

  group('XThemeController Test', () {
    group('boot', () {
      test('boot() should set the default theme', () async {
        expect(controller.value.id, 'Light');
      });

      test('boot() with initial theme should set the initial theme', () async {
        final controller = XThemeController(
          config: getTestConfig(),
          theme: lightTestTheme,
        );
        await controller.boot();
        expect(controller.value.id, 'Light');
      });

      test(
          'boot with config with initial theme index should set the default theme',
          () async {
        final controller = XThemeController(
          config: getTestConfig(initialThemeIndex: 1),
        );
        await controller.boot();

        expect(controller.value.id, 'Dark');
      });
    });

    group('UpdateTo()', () {
      test('updateTo() should update the theme to the provided theme',
          () async {
        final theme = controller.availableThemes[1];
        await controller.updateTo(theme);
        expect(controller.value.id, 'Dark');
      });

      test(
          "updateTo() should throw an exception if the theme isn't available in the availableThemes in config",
          () async {
        final theme = themeOutOFTheList;
        try {
          await controller.updateTo(theme);
          expect("updateTo didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('updateByIndex()', () {
      test('updateByIndex() should update the theme to the provided index',
          () async {
        await controller.updateByIndex(1);
        expect(controller.value.id, 'Dark');
      });

      test(
          "updateByIndex() should throw an exception if the provided index is out of range",
          () async {
        try {
          await controller.updateByIndex(100);
          expect("updateByIndex didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<RangeError>());
        }
      });
    });

    group('updateById()', () {
      test('updateById() should update the theme to the provided id', () async {
        await controller.updateById('Light');
        expect(controller.value.id, 'Light');
      });

      test(
          "updateById() should throw an exception if the provided id isn't available in the availableThemes in config",
          () async {
        try {
          await controller.updateById('id');
          expect("updateById didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('nextTheme()', () {
      test('nextTheme() should update the theme to the next theme', () async {
        await controller.nextTheme();
        expect(controller.value.id, 'Dark');
      });
    });

    test(
        'isDeviceInDarkMode() should return true if the device is in dark mode',
        () async {
      final result = XThemeController.isDeviceInDarkMode();
      expect(result, false);
    });

    group('updateToLightMode()', () {
      test(
          'updateToLightMode() should update the theme to the first light theme in supported themes',
          () async {
        await controller.updateToLightMode();
        expect(controller.value.id, 'Light');
      });

      test(
          "updateToLightMode() should throw an exception if there is no light theme in the availableThemes in config",
          () async {
        final controller = XThemeController(
          config: XThemeConfig(
            themes: [
              XTheme(
                id: 'Dark',
                name: 'Dark',
                themeData: ThemeData.dark(),
                isDark: true,
              ),
            ],
          ),
        );
        await controller.boot();
        try {
          await controller.updateToLightMode();
          expect("updateToLightMode didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('updateToDarkMode()', () {
      test(
          'updateToDarkMode() should update the theme to the first dark theme in supported themes',
          () async {
        await controller.updateToDarkMode();
        expect(controller.value.id, 'Dark');
      });

      test(
          'updateToDarkMode() should throw an exception if there is no dark theme in the availableThemes in config',
          () async {
        final controller = XThemeController(
          config: XThemeConfig(
            themes: [
              XTheme(
                id: 'Light',
                name: 'Light',
                themeData: ThemeData.light(),
                isDark: false,
              ),
            ],
          ),
        );
        await controller.boot();
        try {
          await controller.updateToDarkMode();
          expect("updateToDarkMode didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('updateToDeviceMode()', () {
      test(
          'updateToDeviceMode() should update the theme to the first theme that matches the device mode',
          () async {
        await controller.updateToDeviceMode();
        expect(controller.value.id, 'Light');
      });

      test(
          'updateToDeviceMode() should throw an exception if there is no theme that matches the device mode',
          () async {
        final controller = XThemeController(
          config: XThemeConfig(
            themes: [
              XTheme(
                id: 'Light',
                name: 'Light',
                themeData: ThemeData.light(),
                isDark: false,
              ),
            ],
          ),
        );
        await controller.boot();
        try {
          await controller.updateToDeviceMode();
          expect("updateToDeviceMode didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('updateByThemMode', () {
      test(
          'updateByThemeMode() should update the theme to the provided mode [ThemeMode.light]',
          () async {
        await controller.updateByThemeMode(mode: ThemeMode.light);
        expect(controller.value.id, 'Light');
      });

      test(
          'updateByThemeMode() should update the theme to the provided mode [ThemeMode.dark]',
          () async {
        await controller.updateByThemeMode(mode: ThemeMode.dark);
        expect(controller.value.id, 'Dark');
      });

      test(
          'updateByThemeMode() should update the theme to the provided mode [ThemeMode.system]',
          () async {
        await controller.updateByThemeMode(mode: ThemeMode.system);
        expect(controller.value.id, 'Light');
      });
    });
  });
}
