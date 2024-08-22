import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../playx_theme.dart';
import '../utils/animation_utils.dart';

/// XThemeController is responsible for managing and updating the app's theme,
/// including handling theme changes, animations, and theme persistence.
class XThemeController extends ValueNotifier<XTheme> {
  static const lastKnownIndexKey = 'playx.theme.last_known_index';

  static XThemeController? _instance;

  /// Get the instance of the [XThemeController].
  /// Throws an exception if [boot] has not been called before accessing the instance.
  static XThemeController get instance {
    if (_instance == null) {
      throw Exception(
          'PlayxTheme is not initialized. Please call `boot` before accessing the instance.');
    }
    return _instance!;
  }

  /// Theme configuration.
  final PlayxThemeConfig config;

  /// Default theme index.
  int initialIndex = -1;

  /// The current theme being used.
  XTheme get theme => value;

  // Animation
  ui.Image? image;
  final previewContainer = GlobalKey();

  Timer? timer;
  AnimationController? controller;
  PlayxThemeAnimation? themeAnimation;

  XTheme? oldTheme;

  /// Creates an instance of [XThemeController].
  ///
  /// The provided [theme] will be used as the initial theme if provided; otherwise,
  /// the theme at the [initialThemeIndex] from the configuration will be used.
  XThemeController({
    XTheme? theme,
    required this.config,
  }) : super(theme ?? config.themes[config.initialThemeIndex]) {
    int initialThemeIndex = theme != null
        ? availableThemes.indexOf(theme)
        : config.initialThemeIndex;
    if (initialThemeIndex < 0 || initialThemeIndex >= config.themes.length) {
      initialThemeIndex = 0;
    }
    initialIndex = initialThemeIndex;
    currentIndex = initialThemeIndex;
  }

  /// Current theme index.
  int currentIndex = -1;

  /// List of available themes.
  List<XTheme> get availableThemes => config.themes;

  /// Initializes the theme controller by loading the last saved theme index if applicable.
  Future<void> boot() async {
    final lastSavedIndex = await getLastSavedIndexFromPrefs(
        migratePrefsToAsync: config.migratePrefsToAsyncPrefs);
    final lastKnownIndex =
        config.saveTheme ? lastSavedIndex ?? initialIndex : initialIndex;

    currentIndex = lastKnownIndex;

    value = config.themes.atOrNull(
          lastKnownIndex,
        ) ??
        config.themes.first;
    _instance = this;
  }

  /// Retrieves the last saved theme index from preferences.
  ///
  /// If [migratePrefsToAsync] is true, preferences are migrated to asynchronous storage.
  Future<int?> getLastSavedIndexFromPrefs({
    bool migratePrefsToAsync = false,
  }) async {
    await PlayxAsyncPrefs.create();
    int? lastSavedIndex = await PlayxAsyncPrefs.maybeGetInt(
      lastKnownIndexKey,
    );
    if (migratePrefsToAsync && lastSavedIndex == null) {
      await PlayxPrefs.create();
      final lastKnownIndexInPrefs =
          PlayxPrefs.getInt(lastKnownIndexKey, fallback: initialIndex);
      await PlayxAsyncPrefs.setInt(lastKnownIndexKey, lastKnownIndexInPrefs);
      lastSavedIndex = lastKnownIndexInPrefs;
    }
    return lastSavedIndex;
  }

  /// Updates the theme to one from the available theme list.
  ///
  /// The provided [theme] should be in the available themes list in [PlayxThemeConfig].
  /// If [animation] is null, the theme change will not be animated.
  /// If [animation] is provided, the theme change will be animated based on the animation type.
  /// If [forceUpdateNonAnimatedTheme] is true, the app's widget tree will be rebuilt.
  Future<void> _updateTheme({
    required XTheme theme,
    required int index,
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (value == theme) {
      return;
    }
    currentIndex = index;
    final animate = animation != null && controller != null;
    if (animate) {
      await animateTheme(
          theme: theme, controller: controller!, animation: animation);
    } else {
      value = theme;
      if (forceUpdateNonAnimatedTheme) {
        _forceAppUpdate();
      }
    }
    if (config.saveTheme) {
      await PlayxAsyncPrefs.setInt(lastKnownIndexKey, currentIndex);
    }
  }

  /// Forces the app to update the theme by rebuilding the entire widget tree.
  Future<void> _forceAppUpdate() async {
    return WidgetsFlutterBinding.ensureInitialized().performReassemble();
  }

  /// Forces the app to update the theme by rebuilding the entire widget tree.
  void forceUpdateTheme() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forceAppUpdate();
    });
  }

  /// Updates the theme to a specific theme from the available theme list.
  ///
  /// The provided [theme] should be in the available themes list in [PlayxThemeConfig].
  /// If [animation] is null, the theme change will not be animated.
  /// If [animation] is provided, the theme change will be animated based on the animation type.
  /// If [forceUpdateNonAnimatedTheme] is true, the app's widget tree will be rebuilt.
  Future<void> updateTo(
    XTheme theme, {
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (!availableThemes.contains(theme)) {
      throw Exception('The provided theme is not in the available theme list');
    }
    return _updateTheme(
      theme: theme,
      index: availableThemes.indexOf(theme),
      animation: animation,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// Switches the theme to the next one in the list.
  ///
  /// If there is no next theme, it will switch to the first one.
  Future<void> nextTheme({
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    final isLastTheme = currentIndex == config.themes.length - 1;

    return updateByIndex(isLastTheme ? 0 : currentIndex + 1,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Updates the theme to one by its index in the available themes list.
  ///
  /// The [index] should be within the range of the available themes list.
  /// Throws a [RangeError] if the index is out of range.
  Future<void> updateByIndex(
    int index, {
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (index < 0 || index >= availableThemes.length) {
      throw RangeError(
          'The provided index is out of range of available themes list');
    }
    return _updateTheme(
        theme: availableThemes[index],
        index: index,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Updates the theme to one by its ID in the available themes list.
  ///
  /// The [id] should match the ID of a theme in the available themes list.
  /// Throws an exception if the ID is not found.
  Future<void> updateById(
    String id, {
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (!availableThemes.any((element) => element.id == id)) {
      throw Exception('The provided id is not in the available themes list');
    }

    final index = availableThemes.indexWhere((element) => element.id == id);
    return _updateTheme(
        theme: availableThemes[index],
        index: index,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Returns whether the device is currently in dark mode.
  static bool isDeviceInDarkMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /// Updates the theme to the first light theme in the available themes list.
  ///
  /// Throws an exception if no light theme is found.
  Future<void> updateToLightMode({
    bool animate = true,
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    final theme = config.themes.firstWhereOrNull((element) => !element.isDark);
    if (theme == null) {
      throw Exception('Could not find any light theme in the available themes');
    }
    return updateTo(theme,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  ///Update the theme to the first dark theme in supported themes.
  ///If there is no dark theme, it will throw an exception.
  Future<void> updateToDarkMode({
    bool animate = true,
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    final theme = config.themes.firstWhereOrNull((element) => element.isDark);
    if (theme == null) {
      throw Exception('Could not find any dark theme in the available themes');
    }
    return updateTo(
      theme,
      animation: animation,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// Update the theme to the first theme that matches the device mode.
  /// If there is no theme that matches the device mode, it will throw an exception.
  Future<void> updateToDeviceMode({
    bool animate = true,
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    final theme = config.themes
        .firstWhereOrNull((element) => element.isDark == isDeviceInDarkMode());
    if (theme == null) {
      throw Exception('Could not find any theme that matches the device mode');
    }
    return updateTo(theme,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Update the theme to the first theme that matches the given mode.
  Future<void> updateByThemeMode({
    required ThemeMode mode,
    PlayxThemeAnimation? animation = const PlayxThemeAnimation.fade(),
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    switch (mode) {
      case ThemeMode.system:
        return updateToDeviceMode(
            animation: animation,
            forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
      case ThemeMode.light:
        return updateToLightMode(
            animation: animation,
            forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
      case ThemeMode.dark:
        return updateToDarkMode(
            animation: animation,
            forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
    }
  }

  /// Clear the last saved theme index.
  static Future<void> clearLastSavedTheme() {
    return PlayxAsyncPrefs.remove(lastKnownIndexKey);
  }

  /// Animate the theme change.
  Future<void> animateTheme({
    required XTheme theme,
    required AnimationController controller,
    required PlayxThemeAnimation animation,
  }) async {
    if (controller.isAnimating) {
      controller.reset();
      if (oldTheme != null) {
        value = oldTheme!;
      }
    }
    controller.duration = animation.duration;

    oldTheme = value;

    image =
        await AnimationUtils.saveScreenshot(previewContainer: previewContainer);
    value = theme;

    themeAnimation = animation;
    await animation.animate(
      controller: controller,
    );

    // Notify listeners when the animation finishes.
    notifyListeners();
  }

  /// Update the theme animation controller.
  void updateThemeAnimationController(AnimationController? controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    timer?.cancel();
    _instance = null;
    super.dispose();
  }
}
