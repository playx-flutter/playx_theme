import 'package:flutter/widgets.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/playx_theme.dart';

///XThemeController used to handle all operations on themes like how to change theme, etc.
class XThemeController extends GetxController {
  static const lastKnownIndexKey = 'playx.theme.last_known_index';

  XThemeConfig get config => Get.find<XThemeConfig>();

  late XTheme? _current;

  XTheme get currentXTheme => _current ?? config.themes.first;

  /// current theme index
  int get currentIndex => config.themes.indexOf(currentXTheme);

  /// set up the base controller
  Future<void> boot() async {
    final lastKnownIndex = Prefs.getInt(lastKnownIndexKey);

    /// *
    _current = config.themes.atOrNull(
          lastKnownIndex ?? 0,
        ) ??
        config.themes.first;
  }

  /// update the theme to one of the theme list.
  Future<void> updateTo(XTheme theme, {bool forceUpdateTheme = true}) async {
    _current = theme;
    await Prefs.setInt(lastKnownIndexKey, currentIndex);
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
      await Prefs.setInt(lastKnownIndexKey, index);
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
      await Prefs.setInt(lastKnownIndexKey, currentIndex);
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
}
