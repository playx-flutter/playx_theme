import 'package:flutter/material.dart';
import 'package:playx_theme/src/config/config.dart';
import 'package:playx_theme/src/controller/controller.dart';
import 'package:playx_theme/src/model/playx_colors.dart';
import 'package:playx_theme/src/model/playx_theme_animation.dart';
import 'package:playx_theme/src/model/x_theme.dart';

/// Manages the app's theme and provides methods to update it.
abstract class PlayxTheme {
  static XThemeController? _themeControllerInstance;

  static XThemeController get _controller {
    if (_themeControllerInstance == null) {
      throw Exception(
          "PlayxTheme is not initialized. Please call boot() before accessing PlayxTheme.");
    }
    return _themeControllerInstance!;
  }

  /// Initializes the theme management system.
  ///
  /// This method sets up the theme controller with the provided configuration.
  /// Ensure to call this method before using other `PlayxTheme` methods.
  static Future<void> boot({
    required PlayxThemeConfig config,
  }) async {
    final controller = XThemeController(config: config);
    _themeControllerInstance = controller;
    return controller.boot();
  }

  /// Gets the index of the currently active theme.
  ///
  /// The index represents the position of the current theme in the list of supported themes.
  static int get index => _controller.currentIndex;

  /// Gets the currently active theme.
  ///
  /// This returns the `XTheme` object that represents the current theme.
  static XTheme get currentTheme => _controller.value;

  /// Gets the `ThemeData` for the current theme.
  ///
  /// This provides the `ThemeData` that Flutter uses to style the app based on the current theme.
  static ThemeData get currentThemeData => currentTheme.themeData;

  /// Gets the colors used in the current theme.
  ///
  /// This returns an object containing the color palette for the current theme.
  static PlayxColors get colors => currentTheme.colors;

  /// Gets the name of the currently active theme.
  ///
  /// This returns a human-readable name for the current theme.
  static String get name => _controller.value.name;

  /// Gets the ID of the currently active theme.
  ///
  /// This returns a unique identifier for the current theme.
  static String get id => _controller.value.id;

  /// Gets the initial theme based on the configuration.
  ///
  /// This returns the theme that was set to be the initial theme, or `null` if no initial theme is set.
  static XTheme? get initialTheme =>
      _controller.config.initialThemeIndex >= 0 &&
              _controller.config.initialThemeIndex < supportedThemes.length
          ? supportedThemes[_controller.config.initialThemeIndex]
          : null;

  /// Gets the list of all supported themes.
  ///
  /// This returns a list of `XTheme` objects that are available for use.
  static List<XTheme> get supportedThemes => _controller.config.themes;

  /// Updates the app's theme to the provided theme.
  ///
  /// You can specify an animation for the theme change using the [animation] parameter.
  /// If [animation] is `null`, the theme will change instantly. If [animation] is provided,
  /// the theme change will be animated according to the type of animation specified.
  /// Use [forceUpdateNonAnimatedTheme] to force a theme update without animation if animation is disabled.
  ///
  /// Throws an [Exception] if the provided theme is not available in the supported themes.
  static Future<void> updateTo(
    XTheme theme, {
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) =>
      _controller.updateTo(
        theme,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
      );

  /// Updates the app's theme to the theme at the specified index.
  ///
  /// You can specify an animation for the theme change using the [animation] parameter.
  /// If [animation] is `null`, the theme will change instantly. If [animation] is provided,
  /// the theme change will be animated according to the type of animation specified.
  /// Use [forceUpdateNonAnimatedTheme] to force a theme update without animation if animation is disabled.
  ///
  /// Throws a [RangeError] if the index is out of range.
  static Future<void> updateByIndex(
    int index, {
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) =>
      _controller.updateByIndex(
        index,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
      );

  /// Updates the app's theme to the theme with the specified ID.
  ///
  /// You can specify an animation for the theme change using the [animation] parameter.
  /// If [animation] is `null`, the theme will change instantly. If [animation] is provided,
  /// the theme change will be animated according to the type of animation specified.
  /// Use [forceUpdateNonAnimatedTheme] to force a theme update without animation if animation is disabled.
  ///
  /// Throws an [Exception] if the ID is not available in the supported themes.
  static Future<void> updateById(
    String id, {
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) =>
      _controller.updateById(
        id,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
      );

  /// Updates the app's theme to the next theme in the list.
  ///
  /// You can specify an animation for the theme change using the [animation] parameter.
  /// If [animation] is `null`, the theme will change instantly. If [animation] is provided,
  /// the theme change will be animated according to the type of animation specified.
  /// Use [forceUpdateNonAnimatedTheme] to force a theme update without animation if animation is disabled.
  static Future<void> next({
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) =>
      _controller.nextTheme(
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
      );

  /// Determines if the device is currently in dark mode.
  ///
  /// Returns `true` if the device is in dark mode, otherwise returns `false`.
  static bool isDeviceInDarkMode() {
    return XThemeController.isDeviceInDarkMode();
  }

  /// Updates the app's theme to the first light theme available.
  ///
  /// You can specify an animation for the theme change using the [animation] parameter.
  /// If [animation] is `null`, the theme will change instantly. If [animation] is provided,
  /// the theme change will be animated according to the type of animation specified.
  /// Use [forceUpdateNonAnimatedTheme] to force a theme update without animation if animation is disabled.
  ///
  /// Throws an [Exception] if no light theme is available in the supported themes.
  static Future<void> updateToLightMode({
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    return _controller.updateToLightMode(
      animation: animation,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// Updates the app's theme to the first dark theme available.
  ///
  /// You can specify an animation for the theme change using the [animation] parameter.
  /// If [animation] is `null`, the theme will change instantly. If [animation] is provided,
  /// the theme change will be animated according to the type of animation specified.
  /// Use [forceUpdateNonAnimatedTheme] to force a theme update without animation if animation is disabled.
  ///
  /// Throws an [Exception] if no dark theme is available in the supported themes.
  static Future<void> updateToDarkMode({
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    return _controller.updateToDarkMode(
      animation: animation,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// Updates the app's theme to the first theme that matches the device's current mode.
  ///
  /// You can specify an animation for the theme change using the [animation] parameter.
  /// If [animation] is `null`, the theme will change instantly. If [animation] is provided,
  /// the theme change will be animated according to the type of animation specified.
  /// Use [forceUpdateNonAnimatedTheme] to force a theme update without animation if animation is disabled.
  ///
  /// Throws an [Exception] if no theme matching the device's mode is available in the supported themes.
  static Future<void> updateToDeviceMode({
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    return _controller.updateToDeviceMode(
      animation: animation,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// Updates the app's theme to the first theme that matches the given [ThemeMode].
  ///
  /// You can specify an animation for the theme change using the [animation] parameter.
  /// If [animation] is `null`, the theme will change instantly. If [animation] is provided,
  /// the theme change will be animated according to the type of animation specified.
  /// Use [forceUpdateNonAnimatedTheme] to force a theme update without animation if animation is disabled.
  ///
  /// Throws an [Exception] if no theme matching the given [ThemeMode] is found in the [supportedThemes].
  static Future<void> updateByThemeMode({
    required ThemeMode mode,
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    return _controller.updateByThemeMode(
      mode: mode,
      animation: animation,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// Clears the last saved theme from local storage.
  ///
  /// This method removes the theme data that was previously saved to allow the app to revert to default settings or choose a new theme.
  static Future<void> clearLastSavedTheme() async {
    return XThemeController.clearLastSavedTheme();
  }

  /// Disposes of the Playx theme dependencies.
  ///
  /// This method should be called when theme management is no longer needed to clean up resources.
  /// It returns `true` if the disposal was successful, otherwise returns `false`.
  static Future<bool> dispose() async {
    if (_themeControllerInstance != null) {
      _themeControllerInstance!.dispose();
      _themeControllerInstance = null;
    }
    return true;
  }
}
