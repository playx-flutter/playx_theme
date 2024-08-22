import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/src/config/config.dart';
import 'package:playx_theme/src/controller/controller.dart';
import 'package:playx_theme/src/model/playx_colors.dart';
import 'package:playx_theme/src/model/playx_theme_animation.dart';
import 'package:playx_theme/src/model/x_theme.dart';

/// PlayxTheme :
/// It controls current app theme and how to change current theme.
abstract class PlayxTheme {
  static XThemeController? _themeControllerInstance;

  static XThemeController get _controller {
    if (_themeControllerInstance == null) {
      throw Exception(
          "PlayxTheme is not initialized. Please call boot() before accessing PlayxTheme.");
    }
    return _themeControllerInstance!;
  }

  /// Used to setup AppTheme.
  /// Must be called to initialize dependencies.
  static Future<void> boot({
    required PlayxThemeConfig config,
  }) async {
    final controller = XThemeController(config: config);
    _themeControllerInstance = controller;
    return controller.boot();
  }

  /// Returns current theme index
  static int get index => _controller.currentIndex;

  /// Returns current `XTheme`.
  static XTheme get currentTheme => _controller.value;

  /// Returns current `ThemeData`
  static ThemeData get currentThemeData => currentTheme.themeData;

  /// Returns current `XTheme` colors.
  static PlayxColors get colors => currentTheme.colors;

  /// Returns current theme name.
  static String get name => _controller.value.name;

  /// Returns current theme id.
  static String get id => _controller.value.id;

  /// Returns Start theme if provided.
  static XTheme? get initialTheme =>
      _controller.config.initialThemeIndex >= 0 &&
              _controller.config.initialThemeIndex < supportedThemes.length
          ? supportedThemes[_controller.config.initialThemeIndex]
          : null;

  /// Returns list of supported XThemes.
  static List<XTheme> get supportedThemes => _controller.config.themes;

  /// Updates the app theme to the provided theme.
  /// By Default, It Updates the app theme with an animation which can be disabled using the [animate] parameter.
  /// The animation's starting point can be customized using the [offset] parameter or automatically set to the widget's position using the [context] parameter.
  /// If both [offset] and [context] are provided, [offset] takes precedence.
  /// If neither [offset] nor [context] is provided, the animation starts from the center of the screen.
  /// The direction of the animation can be controlled using the [isReversed] parameter; if provided, the animation will reverse based on its value,
  /// otherwise, it will be determined by the current theme index.
  /// Optionally, a custom [clipper] can be provided to clip the animation. Accepted values are [ThemeSwitcherBoxClipper] or [ThemeSwitcherCircleClipper].
  /// If animate is disabled, [ forceUpdateNonAnimatedTheme] can be used to force update the theme without animation.
  /// if the theme is available in the availableThemes in config, it throw an [Exception].
  ///
  /// Example:
  /// ```dart
  /// // Update them and start animation from a specific offset
  /// PlayxTheme.updateTo(XTheme(
  ///  id: '1',
  ///  name: 'Light Theme',
  ///  themeData: ThemeData.light(),),
  /// animate: true, offset: Offset(0.5, 0.5));
  /// ```
  static Future<void> updateTo(XTheme theme,
          {bool animate = true,
          BuildContext? context,
          PlayxThemeAnimation? animation,
          bool forceUpdateNonAnimatedTheme = false}) =>
      _controller.updateTo(theme,
          animate: animate,
          context: context,
          animation: animation,
          forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);

  /// Updates the app theme by the index.
  /// By Default, It Updates the app theme with an animation which can be disabled using the [animate] parameter.
  /// The animation's starting point can be customized using the [offset] parameter or automatically set to the widget's position using the [context] parameter.
  /// If both [offset] and [context] are provided, [offset] takes precedence.
  /// If neither [offset] nor [context] is provided, the animation starts from the center of the screen.
  /// The direction of the animation can be controlled using the [isReversed] parameter; if provided, the animation will reverse based on its value,
  /// otherwise, it will be determined by the current theme index.
  /// Optionally, a custom [clipper] can be provided to clip the animation. Accepted values are [ThemeSwitcherBoxClipper] or [ThemeSwitcherCircleClipper].
  /// If animate is disabled, [ forceUpdateNonAnimatedTheme] can be used to force update the theme without animation.
  /// if index is out of range , it will throw a [RangeError] exception.
  static Future<void> updateByIndex(int index,
          {bool animate = true,
          BuildContext? context,
          PlayxThemeAnimation? animation,
          bool forceUpdateNonAnimatedTheme = false}) =>
      _controller.updateByIndex(index,
          animate: animate,
          context: context,
          animation: animation,
          forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);

  /// Updates the app theme to the provided id.
  /// By Default, It Updates the app theme with an animation which can be disabled using the [animate] parameter.
  /// The animation's starting point can be customized using the [offset] parameter or automatically set to the widget's position using the [context] parameter.
  /// If both [offset] and [context] are provided, [offset] takes precedence.
  /// If neither [offset] nor [context] is provided, the animation starts from the center of the screen.
  /// The direction of the animation can be controlled using the [isReversed] parameter; if provided, the animation will reverse based on its value,
  /// otherwise, it will be determined by the current theme index.
  /// Optionally, a custom [clipper] can be provided to clip the animation. Accepted values are [ThemeSwitcherBoxClipper] or [ThemeSwitcherCircleClipper].
  /// If animate is disabled, [ forceUpdateNonAnimatedTheme] can be used to force update the theme without animation.
  /// if the id isn't available in the availableThemes in config, it will throw an [Exception].
  static Future<void> updateById(
    String id, {
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) =>
      _controller.updateById(id,
          animate: animate,
          context: context,
          animation: animation,
          forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);

  /// Updates the app theme to the next theme.
  /// By Default, It Updates the app theme with an animation which can be disabled using the [animate] parameter.
  /// The animation's starting point can be customized using the [offset] parameter or automatically set to the widget's position using the [context] parameter.
  /// If both [offset] and [context] are provided, [offset] takes precedence.
  /// If neither [offset] nor [context] is provided, the animation starts from the center of the screen.
  /// The direction of the animation can be controlled using the [isReversed] parameter; if provided, the animation will reverse based on its value,
  /// otherwise, it will be determined by the current theme index.
  /// Optionally, a custom [clipper] can be provided to clip the animation. Accepted values are [ThemeSwitcherBoxClipper] or [ThemeSwitcherCircleClipper].
  /// If animate is disabled, [ forceUpdateNonAnimatedTheme] can be used to force update the theme without animation.
  static Future<void> next({
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) =>
      _controller.nextTheme(
          animate: animate,
          context: context,
          animation: animation,
          forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);

  /// Determines whether the device is in dark or light mode.
  static bool isDeviceInDarkMode() {
    return XThemeController.isDeviceInDarkMode();
  }

  /// Updates the app theme to the first light theme in supported themes.
  /// By Default, It Updates the app theme with an animation which can be disabled using the [animate] parameter.
  /// The animation's starting point can be customized using the [offset] parameter or automatically set to the widget's position using the [context] parameter.
  /// If both [offset] and [context] are provided, [offset] takes precedence.
  /// If neither [offset] nor [context] is provided, the animation starts from the center of the screen.
  /// The direction of the animation can be controlled using the [isReversed] parameter; if provided, the animation will reverse based on its value,
  /// otherwise, it will be determined by the current theme index.
  /// Optionally, a custom [clipper] can be provided to clip the animation. Accepted values are [ThemeSwitcherBoxClipper] or [ThemeSwitcherCircleClipper].
  /// If animate is disabled, [ forceUpdateNonAnimatedTheme] can be used to force update the theme without animation.
  /// if there is no light theme in the availableThemes in config, it will throw an [Exception].
  static Future<void> updateToLightMode({
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    return _controller.updateToLightMode(
        animate: animate,
        context: context,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Updates the app theme to the first dark theme in supported themes.
  /// By Default, It Updates the app theme with an animation which can be disabled using the [animate] parameter.
  /// The animation's starting point can be customized using the [offset] parameter or automatically set to the widget's position using the [context] parameter.
  /// If both [offset] and [context] are provided, [offset] takes precedence.
  /// If neither [offset] nor [context] is provided, the animation starts from the center of the screen.
  /// The direction of the animation can be controlled using the [isReversed] parameter; if provided, the animation will reverse based on its value,
  /// otherwise, it will be determined by the current theme index.
  /// Optionally, a custom [clipper] can be provided to clip the animation. Accepted values are [ThemeSwitcherBoxClipper] or [ThemeSwitcherCircleClipper].
  /// If animate is disabled, [ forceUpdateNonAnimatedTheme] can be used to force update the theme without animation.
  /// if there is no dark theme in the availableThemes in config, it will throw an [Exception].
  static Future<void> updateToDarkMode({
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    return _controller.updateToDarkMode(
        animate: animate,
        context: context,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Updates the app theme to the first theme that matches the given mode.
  /// By Default, It Updates the app theme with an animation which can be disabled using the [animate] parameter.
  /// The animation's starting point can be customized using the [offset] parameter or automatically set to the widget's position using the [context] parameter.
  /// If both [offset] and [context] are provided, [offset] takes precedence.
  /// If neither [offset] nor [context] is provided, the animation starts from the center of the screen.
  /// The direction of the animation can be controlled using the [isReversed] parameter; if provided, the animation will reverse based on its value,
  /// otherwise, it will be determined by the current theme index.
  /// Optionally, a custom [clipper] can be provided to clip the animation. Accepted values are [ThemeSwitcherBoxClipper] or [ThemeSwitcherCircleClipper].
  /// If animate is disabled, [ forceUpdateNonAnimatedTheme] can be used to force update the theme without animation.
  /// if there is no theme that matches the given mode in the availableThemes in config, it will throw an [Exception].
  static Future<void> updateToDeviceMode({
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    return _controller.updateToDeviceMode(
        animate: animate,
        context: context,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Updates the app theme to the first theme that matches the given mode.
  /// By Default, It Updates the app theme with an animation which can be disabled using the [animate] parameter.
  /// The animation's starting point can be customized using the [offset] parameter or automatically set to the widget's position using the [context] parameter.
  /// If both [offset] and [context] are provided, [offset] takes precedence.
  /// If neither [offset] nor [context] is provided, the animation starts from the center of the screen.
  /// The direction of the animation can be controlled using the [isReversed] parameter; if provided, the animation will reverse based on its value,
  /// otherwise, it will be determined by the current theme index.
  /// Optionally, a custom [clipper] can be provided to clip the animation. Accepted values are [ThemeSwitcherBoxClipper] or [ThemeSwitcherCircleClipper].
  /// If animate is disabled, [ forceUpdateNonAnimatedTheme] can be used to force update the theme without animation.
  /// if there is no theme that matches the given mode in the availableThemes in config, it will throw an [Exception].
  static Future<void> updateByThemeMode({
    required ThemeMode mode,
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    return _controller.updateByThemeMode(
        mode: mode,
        animate: animate,
        context: context,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Clears the last saved theme from the local storage.
  static Future<void> clearLastSavedTheme() async {
    return XThemeController.clearLastSavedTheme();
  }

  /// Dispose playx theme dependencies.
  static Future<bool> dispose() async {
    if (_themeControllerInstance != null) {
      _themeControllerInstance!.dispose();
      _themeControllerInstance = null;
    }
    return true;
  }
}
