import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';

import '../config/config.dart';

Future<XThemeController> _boot(List<XTheme> themes) async {
  final c = XThemeController(
    config: PlayxThemeConfig(
      saveTheme: false,
      initialThemeMode: ThemeMode.light,
      themes: themes,
    ),
  );
  await c.boot();
  return c;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('the mode and the theme change together', () async {
    final c = await _boot([lightTestTheme, darkTestTheme]);
    final seen = <String>[];
    void record() => seen.add('${c.value.id}/${c.themeMode.name}');
    c.addListener(record);
    c.themeModeNotifier.addListener(record);

    await c.updateToDarkMode(animate: false);

    // Whenever a listener runs, the pair is either fully old or fully new
    // for the notifier that fired; after the call both are new.
    expect('${c.value.id}/${c.themeMode.name}', 'Dark/dark');
    expect(seen.last, 'Dark/dark');
    expect(seen, isNot(contains('Light/dark')));
    c.dispose();
  });

  test('mode is unchanged when there is no theme for it', () async {
    final c = await _boot([lightTestTheme]);
    await expectLater(c.updateToDarkMode(animate: false), throwsException);
    expect(c.themeMode, ThemeMode.light);
    expect(c.value.id, 'Light');
    c.dispose();
  });

  test('switching modes works when already on the matching theme', () async {
    final c = await _boot([lightTestTheme, darkTestTheme]);
    await c.updateToDeviceMode(animate: false); // device is light
    expect(c.themeMode, ThemeMode.system);
    expect(c.value.id, 'Light');
    c.dispose();
  });

  test('updateMode: false keeps the mode', () async {
    final c = await _boot([lightTestTheme, darkTestTheme]);
    await c.updateByIndex(1, animate: false, updateMode: false);
    expect(c.value.id, 'Dark');
    expect(c.themeMode, ThemeMode.light);
    c.dispose();
  });

  test('rapid calls keep the index and mode of the last request', () async {
    final c = await _boot([lightTestTheme, darkTestTheme]);
    await Future.wait([
      c.updateByIndex(1, animate: false),
      c.updateByIndex(0, animate: false),
    ]);
    expect(c.currentIndex, 0);
    expect(c.value.id, 'Light');
    expect(c.themeMode, ThemeMode.light);
    c.dispose();
  });
}
