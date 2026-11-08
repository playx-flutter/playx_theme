import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';

import '../config/config.dart';

PlayxThemeConfig _config(PlayxThemeStorage storage) => PlayxThemeConfig(
  initialThemeMode: ThemeMode.light,
  themes: [lightTestTheme, darkTestTheme],
  storage: storage,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PlayxMemoryThemeStorage', () {
    test('stores, reads and removes values', () async {
      final storage = PlayxMemoryThemeStorage({'a': 1});
      expect(await storage.getInt('a'), 1);
      expect(await storage.getString('a'), isNull, reason: 'type mismatch');
      await storage.setString('s', 'x');
      expect(await storage.getString('s'), 'x');
      expect(await storage.getInt('s'), isNull);
      await storage.setInt('a', 5);
      expect(await storage.getInt('a'), 5);
      await storage.remove('a');
      expect(await storage.getInt('a'), isNull);
    });
  });

  group('custom storage with PlayxTheme', () {
    tearDown(() => PlayxTheme.dispose());

    test('persists the selected theme and restores it on boot', () async {
      final storage = PlayxMemoryThemeStorage();
      await PlayxTheme.boot(config: _config(storage));
      await PlayxTheme.updateToDarkMode(animate: false);

      expect(await storage.getInt(XThemeController.lastKnownIndexKey), 1);
      expect(
        await storage.getString(XThemeController.lastKnownThemeModeKey),
        'dark',
      );

      await PlayxTheme.boot(config: _config(storage));
      expect(PlayxTheme.id, 'Dark');
      expect(PlayxTheme.themeMode, ThemeMode.dark);
    });

    test('clearLastSavedTheme clears the custom storage', () async {
      final storage = PlayxMemoryThemeStorage();
      await PlayxTheme.boot(config: _config(storage));
      await PlayxTheme.updateToDarkMode(animate: false);
      await PlayxTheme.clearLastSavedTheme();
      expect(await storage.getInt(XThemeController.lastKnownIndexKey), isNull);
      expect(
        await storage.getString(XThemeController.lastKnownThemeModeKey),
        isNull,
      );
    });

    test('does not persist when saveTheme is false', () async {
      final storage = PlayxMemoryThemeStorage();
      await PlayxTheme.boot(
        config: PlayxThemeConfig(
          saveTheme: false,
          themes: [lightTestTheme, darkTestTheme],
          storage: storage,
        ),
      );
      await PlayxTheme.updateToDarkMode(animate: false);
      expect(await storage.getInt(XThemeController.lastKnownIndexKey), isNull);
    });
  });
}
