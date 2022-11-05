import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/config.dart';
import 'package:playx_theme/controller.dart';
import 'package:playx_theme/x_theme.dart';

abstract class AppTheme {
  /// shortcut for the rest of the functions
  static XThemeController get _controller => Get.find<XThemeController>();

  static Future<void> boot({
    XThemeConfig config = const XDefaultThemeConfig(),
  }) async {
    Get
      ..put<XThemeConfig>(config)
      ..put<XThemeController>(XThemeController());
    return _controller.boot();
  }

  /// return current theme index
  static int get index => _controller.currentIndex;

  /// return current `XTheme`
  static XTheme get xTheme => _controller.currentXTheme;

  static String get name => _controller.currentXTheme.nameBuilder();
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

  /// updates the app theme by the index
  /// if index is out of range , it will do nothing
  static Future<void> next() => _controller.nextTheme();
}
