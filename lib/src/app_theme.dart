import 'dart:developer';

import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/src/config/config.dart';
import 'package:playx_theme/src/controller/controller.dart';
import 'package:playx_theme/src/model/x_color_scheme.dart';
import 'package:playx_theme/src/model/x_theme.dart';

/// AppTheme :
/// It controls current app theme and how to change current theme.
abstract class AppTheme {
  /// shortcut for the rest of the functions
  static XThemeController get _controller => Get.find<XThemeController>();

  ///Used to setup AppTheme.
  ///Must be called to initialize dependencies.
  static Future<void> boot({
    XThemeConfig config = const XDefaultThemeConfig(),
  }) async {
    /// * boot the core
    await PlayXCore.bootCore();
    log('[playx] core booted ✔');

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
  static String get name => _controller.currentXTheme.nameBuilder();

  ///Get current theme id
  static String get id => _controller.currentXTheme.id;

  /// return list of supported XThemes
  static List<XTheme> get supportedThemes => _controller.config.themes;

  /// update theme to use the given one
  static Future<void> updateTo(
    XTheme theme,
  ) =>
      _controller.updateTo(theme);

  /// updates the app theme by the index
  /// if index is out of range , it will do nothing
  static Future<void> updateByIndex(
    int index,
  ) =>
      _controller.updateByIndex(index);

  /// updates the app theme to the next theme
  static Future<void> next() => _controller.nextTheme();
}
