
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/src/config/config.dart';
import 'package:playx_theme/src/controller/controller.dart';
import 'package:playx_theme/src/model/x_color_scheme.dart';
import 'package:playx_theme/src/model/x_theme.dart';

/// PlayxTheme :
/// It controls current app theme and how to change current theme.
abstract class PlayxTheme {
  /// shortcut for the rest of the functions
  static XThemeController get _controller => Get.find<XThemeController>();

  ///Used to setup AppTheme.
  ///Must be called to initialize dependencies.
  ///securePrefsSettings is not necessary for only using PlayxTheme package.
  static Future<void> boot({
    XThemeConfig config = const XDefaultThemeConfig(),
    SecurePrefsSettings securePrefsSettings = const SecurePrefsSettings(),
  }) async {

    Get
      ..put<XThemeConfig>(config)
      ..put<XThemeController>(XThemeController());
    return _controller.boot();
  }

  /// Get current theme index
  static int get index => _controller.currentIndex;

  /// Get current `XTheme`
  static XTheme get xTheme => _controller.currentXTheme;

  /// Get current `XTheme` color scheme.
  static XColorScheme get colorScheme => xTheme.colorScheme;

  ///Get current theme name
  static String get name => _controller.currentXTheme.name;

  ///Get current theme id
  static String get id => _controller.currentXTheme.id;

  /// return list of supported XThemes
  static List<XTheme> get supportedThemes => _controller.config.themes;

  /// update theme to use the given one
  static Future<void> updateTo(XTheme theme, {bool forceUpdateTheme = true}) =>
      _controller.updateTo(theme, forceUpdateTheme: forceUpdateTheme);

  /// updates the app theme by the index
  /// if index is out of range , it will do nothing
  static Future<void> updateByIndex(int index,
          {bool forceUpdateTheme = true}) =>
      _controller.updateByIndex(index, forceUpdateTheme: forceUpdateTheme);

  /// updates the app theme by the index
  static Future<void> updateById(String id, {bool forceUpdateTheme = true}) =>
      _controller.updateById(id, forceUpdateTheme: forceUpdateTheme);

  /// updates the app theme to the next theme
  static Future<void> next({bool forceUpdateTheme = true}) =>
      _controller.nextTheme(forceUpdateTheme: forceUpdateTheme);

  static Future<void> dispose() {
    return PlayXCore.dispose();
  }
}
