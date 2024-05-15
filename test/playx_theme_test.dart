import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';

import 'config/config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(
    () async {
      PlayxPrefs.setMockInitialValues({});
      await PlayxCore.bootCore();
      await PlayxTheme.boot(config: getTestConfig());
    },
  );
  tearDown(
    () async {
      await PlayxTheme.clearLastSavedTheme();
      await PlayxCore.dispose();
      await PlayxTheme.dispose();
    },
  );

  group('PlayxTheme test', () {
    group('boot() test', () {
      test('boot() should set the default theme', () async {
        expect(PlayxTheme.index, 0);
      });

      test(
          'boot with config with initial theme index should set the default theme',
          () async {
        await PlayxTheme.dispose();
        await PlayxTheme.boot(
          config: getTestConfig(initialThemeIndex: 1),
        );
        expect(PlayxTheme.index, 1);
      });
      test('boot register PlayxThemeController in Getx DI in memory', () async {
        await PlayxTheme.boot(
          config: getTestConfig(initialThemeIndex: 1),
        );
        final isRegistered = Get.isRegistered<XThemeController>();
        expect(true, isRegistered);
      });
    });

    group('index', () {
      test('PlayxTheme.index should return the current theme index', () async {
        expect(PlayxTheme.index, 0);
      });

      test('PlayxTheme.index should return the current theme index', () async {
        await PlayxTheme.dispose();
        await PlayxTheme.boot(
          config: getTestConfig(initialThemeIndex: 1),
        );
        expect(PlayxTheme.index, 1);
      });

      test(
          'PlayxTheme.index should return the Last saved and current theme index',
          () async {
        await PlayxCore.dispose();
        await PlayxTheme.dispose();

        PlayxPrefs.setMockInitialValues(
            {XThemeController.lastKnownIndexKey: 1});
        await PlayxCore.bootCore();
        await PlayxTheme.boot(config: getTestConfig());

        expect(PlayxTheme.index, 1);
      });
    });

    test('PlayxTheme.xTheme should return the current theme', () async {
      expect(PlayxTheme.currentTheme.id, 'Light');
    });

    test('PlayxTheme.colors should return the current theme colors', () async {
      expect(PlayxTheme.colors, lightTestTheme.colors);
    });

    test('PlayxTheme.name should return the current theme name', () async {
      expect(PlayxTheme.name, 'Light');
    });

    test('PlayxTheme.id should return the current theme id', () async {
      expect(PlayxTheme.id, 'Light');
    });

    test('PlayxTheme.initialTheme should return the start theme if provided',
        () async {
      expect(PlayxTheme.initialTheme, lightTestTheme);
    });

    test('PlayxTheme.supportedThemes should return list of supported XThemes',
        () async {
      expect(PlayxTheme.supportedThemes, getTestConfig().themes);
    });

    group('PlayxTheme.updateTo()', () {
      test(
          'PlayxTheme.updateTo() should update the theme to the provided theme',
          () async {
        final theme = PlayxTheme.supportedThemes[1];
        await PlayxTheme.updateTo(theme);
        expect(PlayxTheme.id, 'Dark');
      });

      test(
          'PlayxTheme.updateTo() should throw an error if the theme is not available in the availableThemes in config',
          () async {
        final theme = themeOutOFTheList;
        try {
          await PlayxTheme.updateTo(theme);
          expect("updateTo didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('PlayxTheme.updateByIndex()', () {
      test('PlayxTheme.updateByIndex() should update the theme by the index',
          () async {
        await PlayxTheme.updateByIndex(1);
        expect(PlayxTheme.id, 'Dark');
      });

      test(
          'PlayxTheme.updateByIndex() should throw a RangeError if the index is out of range',
          () async {
        try {
          await PlayxTheme.updateByIndex(100);
          expect("updateByIndex didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<RangeError>());
        }
      });
    });

    group('PlayxTheme.updateById()', () {
      test('PlayxTheme.updateById() should update the theme by the id',
          () async {
        await PlayxTheme.updateById('Dark');
        expect(PlayxTheme.id, 'Dark');
      });

      test(
          'PlayxTheme.updateById() should throw an error if the id is not available in the availableThemes in config',
          () async {
        try {
          await PlayxTheme.updateById('id');
          expect("updateById didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    test('PlayxTheme.next() should update the theme to the next theme',
        () async {
      await PlayxTheme.next();
      expect(PlayxTheme.id, 'Dark');
    });

    test(
        'PlayxTheme.isDeviceInDarkMode() should return true if the device is in dark mode',
        () async {
      expect(PlayxTheme.isDeviceInDarkMode(), false);
    });

    group('PlayxTheme.updateToLightMode()', () {
      test(
          'PlayxTheme.updateToLightMode() should update the theme to the first light theme in supported themes',
          () async {
        await PlayxTheme.updateToLightMode();
        expect(PlayxTheme.id, 'Light');
      });

      test(
          'PlayxTheme.updateToLightMode() should throw an error if there is no light theme in the availableThemes in config',
          () async {
        try {
          await PlayxTheme.updateToLightMode();
          expect("updateToLightMode didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('PlayxTheme.updateToDarkMode()', () {
      test(
          'PlayxTheme.updateToDarkMode() should update the theme to the first dark theme in supported themes',
          () async {
        await PlayxTheme.updateToDarkMode();
        expect(PlayxTheme.id, 'Dark');
      });

      test(
          'PlayxTheme.updateToDarkMode() should throw an error if there is no dark theme in the availableThemes in config',
          () async {
        try {
          await PlayxTheme.updateToDarkMode();
          expect("updateToDarkMode didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('PlayxTheme.updateToDeviceMode()', () {
      test(
          'PlayxTheme.updateToDeviceMode() should update the theme to the first theme that matches the device mode',
          () async {
        await PlayxTheme.updateToDeviceMode();
        expect(PlayxTheme.id, 'Light');
      });

      test(
          'PlayxTheme.updateToDeviceMode() should throw an error if there is no theme that matches the device mode in the availableThemes in config',
          () async {
        final controller = XThemeController(
          config: PlayxThemeConfig(
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
          await controller.updateToDeviceMode();
          expect("updateToDeviceMode didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    group('PlayxTheme.updateByThemeMode()', () {
      test(
          'PlayxTheme.updateByThemeMode() should update the theme to the first theme that matches the given mode',
          () async {
        await PlayxTheme.updateByThemeMode(mode: ThemeMode.light);
        expect(PlayxTheme.id, 'Light');
      });

      test(
          'PlayxTheme.updateByThemeMode() should throw an error if there is no theme that matches the given mode in the availableThemes in config',
          () async {
        final controller = XThemeController(
          config: PlayxThemeConfig(
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
          await controller.updateByThemeMode(mode: ThemeMode.light);
          expect("updateByThemeMode didn't throw an exception.", false);
        } catch (e) {
          expect(e, isA<Exception>());
        }
      });
    });

    test('PlayxTheme.clearLastSavedTheme()', () async {
      await PlayxTheme.updateByIndex(
        1,
      );

      final index =
          PlayxPrefs.getInt(XThemeController.lastKnownIndexKey, fallback: 0);
      expect(index, 1);

      // await PlayxTheme.clearLastSavedTheme();
      // expect(PlayxPrefs.getInt(XThemeController.lastKnownIndexKey, fallback: 0),
      //     0);
    });

    test('PlayxTheme.dispose() should dispose the PlayxThemeController',
        () async {
      await PlayxTheme.dispose();
      final isRegistered = Get.isRegistered<XThemeController>();
      expect(false, isRegistered);
    });
  });

  group('PlayxThemeBuilder test', () {
    // testWidgets('PlayxThemeBuilder should build the app with the current theme',
    //     (tester) async {
    //   await tester.pumpWidget(
    //     const TestApp(),
    //   );
    //   await tester.pumpAndSettle();
    //   final text = find.text('0');
    //   expect(text, findsOneWidget);
    // });

    //   testWidgets('PlayxThemeBuilder should rebuild the app with the new theme',
    //       (tester) async {
    //     await tester.pumpWidget(
    //       const TestApp(),
    //     );
    //     await tester.pumpAndSettle();
    //     final text = find.text('0');
    //     expect(text, findsOneWidget);
    //
    //     await PlayxTheme.updateToDarkMode();
    //     await tester.pumpAndSettle();
    //     final darkText = find.text('1');
    //     expect(darkText, findsOneWidget);
    //   });
  });
}
