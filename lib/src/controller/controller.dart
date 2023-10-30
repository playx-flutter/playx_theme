import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:playx_theme/playx_theme.dart';

///XThemeController used to handle all operations on themes like how to change theme, etc.
class XThemeController extends GetxController {
  static const lastKnownIndexKey = 'playx.theme.last_known_index';

  XThemeConfig get config => Get.find<XThemeConfig>();

  late XTheme? _current;

  /// Current theme used by the app.
  XTheme get currentXTheme =>
      _current ?? config.themes[config.initialThemeIndex];

  /// current theme index
  int get currentIndex => config.themes.indexOf(currentXTheme);

  ///Default theme index.
  int get _defaultIndex {
    final index = config.initialThemeIndex;
    if (index < 0 || index >= config.themes.length) return 0;
    return index;
  }

  /// set up the base controller
  Future<void> boot() async {
    final lastKnownIndex = config.saveTheme
        ? PlayxPrefs.getInt(lastKnownIndexKey, fallback: _defaultIndex)
        : _defaultIndex;

    _current = config.themes.atOrNull(
          lastKnownIndex,
        ) ??
        config.themes.first;
  }

  /// update the theme to one of the theme list.
  Future<void> updateTo(XTheme theme, {bool forceUpdateTheme = true}) async {
    _current = theme;
    if(config.saveTheme) {
      await PlayxPrefs.setInt(lastKnownIndexKey, currentIndex);
    }
    refresh();

    if (forceUpdateTheme) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.forceAppUpdate();
      });
    }
  }

  /// switch the theme to the next in the list
  /// if there is no next theme, it will switch to the first one
  Future<void> nextTheme({bool forceUpdateTheme = true}) async {
    final isLastTheme = currentIndex == config.themes.length - 1;

    await updateByIndex(isLastTheme ? 0 : currentIndex + 1,
        forceUpdateTheme: forceUpdateTheme);
  }

  /// update the theme to by index
  Future<void> updateByIndex(int index, {bool forceUpdateTheme = true}) async {
    try {
      _current = config.themes[index];

      if(config.saveTheme) {
        await PlayxPrefs.setInt(lastKnownIndexKey, index);
      }
      refresh();
      if (forceUpdateTheme) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.forceAppUpdate();
        });
      }
    } catch (err) {
      err.printError(info: 'Playx Theme :');
      if (err is! RangeError) rethrow;
    }
  }

  /// update the theme to by index
  Future<void> updateById(String id, {bool forceUpdateTheme = true}) async {
    try {
      _current = config.themes.firstWhere((element) => element.id == id);
      if(config.saveTheme) {
        await PlayxPrefs.setInt(lastKnownIndexKey, currentIndex);
      }
      refresh();
      if (forceUpdateTheme) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.forceAppUpdate();
        });
      }
    } catch (err) {
      err.printError(info: 'Playx Theme :');
      if (err is! RangeError) rethrow;
    }
  }

  ///Whether the device is currently in dark mode
  /// Can be used to show theme based on user mode.
  bool isDeviceInDarkMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /// update the theme to the first light theme in supported themes.
  Future<void> updateToLightMode({bool forceUpdateTheme = true}) {
    final theme = config.themes.firstWhereOrNull((element) => !element.isDark);
    if (theme == null) throw Exception('No light theme found');
    return updateTo(theme, forceUpdateTheme: forceUpdateTheme);
  }

  ///Update the theme to the first dark theme in supported themes.
  Future<void> updateToDarkMode({bool forceUpdateTheme = true}) {
    final theme = config.themes.firstWhereOrNull((element) => element.isDark);
    if (theme == null) throw Exception('No Dark theme found');
    return updateTo(theme, forceUpdateTheme: forceUpdateTheme);
  }

  /// Update the theme to the first theme that matches the device mode.
  Future<void> updateToDeviceMode({bool forceUpdateTheme = true}) {
    final theme = config.themes
        .firstWhereOrNull((element) => element.isDark == isDeviceInDarkMode());
    if (theme == null) throw Exception('No theme found for device mode');
    return updateTo(theme, forceUpdateTheme: forceUpdateTheme);
  }

  /// Update the theme to the first theme that matches the given mode.
  Future<void> updateByThemeMode(
      {required ThemeMode mode, bool forceUpdateTheme = true}) {
    switch (mode) {
      case ThemeMode.system:
        return updateToDeviceMode(forceUpdateTheme: forceUpdateTheme);
      case ThemeMode.light:
        return updateToLightMode(forceUpdateTheme: forceUpdateTheme);
      case ThemeMode.dark:
        return updateToDarkMode(forceUpdateTheme: forceUpdateTheme);
    }
  }
}
