import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../playx_theme.dart';
import '../utils/animation_utils.dart';

/// XThemeController is responsible for managing and updating the app's theme,
/// including handling theme changes, animations, and theme persistence.
class XThemeController extends ValueNotifier<XTheme>
    with WidgetsBindingObserver {
  static const lastKnownIndexKey = 'playx.theme.last_known_index';
  static const lastKnownThemeModeKey = 'playx.theme.last_known_theme_mode';

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

  final ValueNotifier<ThemeMode> _themeModeNotifier =
      ValueNotifier(ThemeMode.system);

  /// The notifier for current theme mode.
  ValueNotifier<ThemeMode> get themeModeNotifier => _themeModeNotifier;

  /// The current theme mode (system, light, or dark).
  ThemeMode get themeMode => _themeModeNotifier.value;

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
  /// the theme from [getInitialThemeByConfig] will be used.
  XThemeController({
    XTheme? theme,
    required this.config,
  }) : super(theme ?? getInitialThemeByConfig(config)) {
    var initialThemeIdx =
        availableThemes.indexOf(theme ?? getInitialThemeByConfig(config));
    if (initialThemeIdx < 0 || initialThemeIdx >= config.themes.length) {
      initialThemeIdx = 0;
    }
    initialIndex = initialThemeIdx;
    currentIndex = initialThemeIdx;
  }

  /// Current theme index.
  int currentIndex = -1;

  /// List of available themes.
  List<XTheme> get availableThemes => config.themes;
  static PlayxBaseLogger get logger => PlayxLogger.getLogger('PLAYX THEME')!;

  /// Retrieves the optional explicitly set theme mode, or system by default.
  ThemeMode getInitialThemeMode() {
    if (config.initialThemeIndex != null &&
        config.initialThemeIndex! >= 0 &&
        config.initialThemeIndex! < config.themes.length) {
      final theme = config.themes[config.initialThemeIndex!];
      return theme.isDark ? ThemeMode.dark : ThemeMode.light;
    } else if (config.initialThemeMode != null) {
      return config.initialThemeMode!;
    } else {
      return ThemeMode.system;
    }
  }

  /// Retrieves the initial theme based on the configuration.
  XTheme getInitialTheme() => getInitialThemeByConfig(config);

  /// Helper to retrieve the initial theme using a configuration object before initialization.
  static XTheme getInitialThemeByConfig(PlayxThemeConfig config) {
    if (config.initialThemeIndex != null &&
        config.initialThemeIndex! >= 0 &&
        config.initialThemeIndex! < config.themes.length) {
      return config.themes[config.initialThemeIndex!];
    }

    if (config.initialThemeMode != null) {
      if (config.initialThemeMode == ThemeMode.system) {
        return _getThemeForModeStatic(config, isDeviceInDarkMode()) ??
            config.themes.first;
      } else if (config.initialThemeMode == ThemeMode.light) {
        return _getThemeForModeStatic(config, false) ?? config.themes.first;
      } else {
        return _getThemeForModeStatic(config, true) ?? config.themes.first;
      }
    }

    return _getThemeForModeStatic(config, isDeviceInDarkMode()) ??
        config.themes.first;
  }

  /// Initializes the theme controller by loading the last saved theme index if applicable.
  Future<void> boot() async {
    final lastSavedIndex = config.saveTheme
        ? await getLastSavedIndexFromPrefs(
            migratePrefsToAsync: config.migratePrefsToAsyncPrefs)
        : null;

    final lastSavedThemeModeString = config.saveTheme
        ? await PlayxAsyncPrefs.maybeGetString(lastKnownThemeModeKey)
        : null;

    ThemeMode computedMode;
    if (lastSavedThemeModeString != null) {
      computedMode = ThemeMode.values.firstWhere(
        (e) => e.name == lastSavedThemeModeString,
        orElse: () => ThemeMode.system,
      );
    } else {
      computedMode = getInitialThemeMode();
    }

    _themeModeNotifier.value = computedMode;

    if (lastSavedThemeModeString != null && computedMode == ThemeMode.system) {
      value = _getThemeForMode(isDeviceInDarkMode()) ?? availableThemes.first;
    } else {
      if (lastSavedThemeModeString == null) {
        value = getInitialTheme();
      } else {
        if (lastSavedIndex != null &&
            lastSavedIndex >= 0 &&
            lastSavedIndex < availableThemes.length) {
          value = availableThemes[lastSavedIndex];
        } else {
          if (computedMode == ThemeMode.light) {
            value = _getThemeForMode(false) ?? availableThemes.first;
          } else {
            value = _getThemeForMode(true) ?? availableThemes.first;
          }
        }
      }
    }

    currentIndex = availableThemes.indexOf(value);
    initialIndex = currentIndex;

    _instance = this;
    WidgetsBinding.instance.addObserver(this);
    logger.info(
      'Initialized with theme: ${value.id} at index: $currentIndex, mode: ${_themeModeNotifier.value.name}',
    );
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    if (_themeModeNotifier.value == mode) return;
    _themeModeNotifier.value = mode;
    if (config.saveTheme) {
      await PlayxAsyncPrefs.setString(lastKnownThemeModeKey, mode.name);
    }
  }

  XTheme? _getThemeForMode(bool isDark) =>
      _getThemeForModeStatic(config, isDark);

  static XTheme? _getThemeForModeStatic(PlayxThemeConfig config, bool isDark) {
    if (isDark) {
      if (config.darkThemeIndex != null &&
          config.darkThemeIndex! >= 0 &&
          config.darkThemeIndex! < config.themes.length) {
        return config.themes[config.darkThemeIndex!];
      }
      return config.themes.firstWhereOrNull((element) => element.isDark);
    } else {
      if (config.lightThemeIndex != null &&
          config.lightThemeIndex! >= 0 &&
          config.lightThemeIndex! < config.themes.length) {
        return config.themes[config.lightThemeIndex!];
      }
      return config.themes.firstWhereOrNull((element) => !element.isDark);
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (_themeModeNotifier.value == ThemeMode.system) {
      final currentTheme =
          _getThemeForMode(isDeviceInDarkMode()) ?? config.themes.first;
      _updateTheme(
        theme: currentTheme,
        index: availableThemes.indexOf(currentTheme),
        animate: false,
        updateMode: false,
      );
    }
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
  /// If [animate] is false, the theme change will not be animated.
  /// If [animation] is provided, the theme change will be animated based on the animation type.
  /// If [forceUpdateNonAnimatedTheme] is true, the app's widget tree will be rebuilt.
  /// If [updateMode] is true, the `themeMode` is updated to light or dark based on the theme's brightness.
  Future<void> _updateTheme({
    required XTheme theme,
    required int index,
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
    bool updateMode = true,
  }) async {
    if (value == theme) {
      if (config.logThemeChanges) {
        logger
            .warning('Theme is already set to ${theme.id}, no update needed.');
      }
      return;
    }
    if (index < 0 || index >= availableThemes.length) {
      throw RangeError(
          'The provided index is out of range of available themes list');
    }
    if (updateMode) {
      await _setThemeMode(theme.isDark ? ThemeMode.dark : ThemeMode.light);
    }
    if (config.logThemeChanges) {
      logger.info(
        'Updating theme from ${value.id} to ${theme.id} at index $index with animation enabled : $animate',
      );
    }
    currentIndex = index;
    final shouldAnimate = animate && controller != null;
    if (shouldAnimate) {
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
  /// If [animate] is false, the theme change will not be animated.
  /// If [animation] is provided, the theme change will be animated based on the animation type.
  /// If [forceUpdateNonAnimatedTheme] is true, the app's widget tree will be rebuilt.
  /// If [updateMode] is true, the `themeMode` is updated based on the theme's brightness.
  Future<void> updateTo(
    XTheme theme, {
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
    bool updateMode = true,
  }) async {
    if (!availableThemes.contains(theme)) {
      if (config.logThemeChanges) {
        logger.error('Theme ${theme.id} not found in available themes.');
      }
      throw Exception('The provided theme is not in the available theme list');
    }
    return _updateTheme(
      theme: theme,
      index: availableThemes.indexOf(theme),
      animation: animation,
      animate: animate,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
      updateMode: updateMode,
    );
  }

  /// Switches the theme to the next one in the list.
  ///
  /// If there is no next theme, it will switch to the first one.
  /// If [updateMode] is true, the `themeMode` is updated based on the theme's brightness.
  Future<void> nextTheme({
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
    bool updateMode = true,
  }) async {
    final isLastTheme = currentIndex == config.themes.length - 1;

    return updateByIndex(isLastTheme ? 0 : currentIndex + 1,
        animation: animation,
        animate: animate,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
        updateMode: updateMode,
    );
  }

  /// Updates the theme to one by its index in the available themes list.
  ///
  /// The [index] should be within the range of the available themes list.
  /// Throws a [RangeError] if the index is out of range.
  /// If [updateMode] is true, the `themeMode` is updated based on the theme's brightness.
  Future<void> updateByIndex(
    int index, {
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
    bool updateMode = true,
  }) async {
    if (index < 0 || index >= availableThemes.length) {
      logger.e('Index $index is out of range for available themes list.');
      throw RangeError(
          'The provided index is out of range of available themes list');
    }
    return _updateTheme(
        theme: availableThemes[index],
        index: index,
        animation: animation,
        animate: animate,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
        updateMode: updateMode,
    );
  }

  /// Updates the theme to one by its ID in the available themes list.
  ///
  /// The [id] should match the ID of a theme in the available themes list.
  /// Throws an exception if the ID is not found.
  /// If [updateMode] is true, the `themeMode` is updated based on the theme's brightness.
  Future<void> updateById(
    String id, {
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
    bool updateMode = true,
  }) async {
    if (!availableThemes.any((element) => element.id == id)) {
      if (config.logThemeChanges) {
        logger.error('Theme with id $id not found in available themes.');
      }
      throw Exception('The provided id is not in the available themes list');
    }

    final index = availableThemes.indexWhere((element) => element.id == id);
    return _updateTheme(
        theme: availableThemes[index],
        index: index,
        animation: animation,
        animate: animate,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
        updateMode: updateMode,
    );
  }

  /// Returns whether the device is currently in dark mode.
  static bool isDeviceInDarkMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /// Updates the theme to the first light theme in the available themes list
  /// (or uses `lightThemeIndex` if specified in config).
  ///
  /// Throws an exception if no light theme is found.
  Future<void> updateToLightMode({
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    final theme = _getThemeForMode(false);
    if (theme == null) {
      if (config.logThemeChanges) {
        logger.error('Could not find any light theme in the available themes');
      }
      throw Exception('Could not find any light theme in the available themes');
    }
    await _setThemeMode(ThemeMode.light);
    return updateTo(theme,
        animation: animation,
        animate: animate,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
        updateMode: false);
  }

  ///Update the theme to the first dark theme in supported themes
  /// (or uses `darkThemeIndex` if specified in config).
  ///If there is no dark theme, it will throw an exception.
  Future<void> updateToDarkMode({
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    final theme = _getThemeForMode(true);
    if (theme == null) {
      if (config.logThemeChanges) {
        logger.error('Could not find any dark theme in the available themes');
      }
      throw Exception('Could not find any dark theme in the available themes');
    }
    await _setThemeMode(ThemeMode.dark);
    return updateTo(
      theme,
      animation: animation,
      animate: animate,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
      updateMode: false,
    );
  }

  /// Update the theme to the first theme that matches the device mode
  /// (or uses `lightThemeIndex`/`darkThemeIndex` if specified in config).
  /// If there is no theme that matches the device mode, it will throw an exception.
  Future<void> updateToDeviceMode({
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    XTheme? theme = _getThemeForMode(isDeviceInDarkMode());
    if (theme == null) {
      if (config.logThemeChanges) {
        logger.error(
            'Could not find any theme that matches the device mode: ${isDeviceInDarkMode()}');
      }
      throw Exception('Could not find any theme that matches the device mode');
    }
    await _setThemeMode(ThemeMode.system);
    return updateTo(theme,
        animation: animation,
        animate: animate,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
        updateMode: false);
  }

  /// Update the theme to the first theme that matches the given mode.
  Future<void> updateByThemeMode({
    required ThemeMode mode,
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    await _setThemeMode(mode);
    switch (mode) {
      case ThemeMode.system:
        return updateToDeviceMode(
            animation: animation,
            animate: animate,
            forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
      case ThemeMode.light:
        return updateToLightMode(
            animation: animation,
            animate: animate,
            forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
      case ThemeMode.dark:
        return updateToDarkMode(
            animation: animation,
            animate: animate,
            forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
    }
  }

  /// Clear the last saved theme index and theme mode.
  static Future<void> clearLastSavedTheme() async {
    await PlayxAsyncPrefs.remove(lastKnownThemeModeKey);
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
    WidgetsBinding.instance.removeObserver(this);
    _themeModeNotifier.dispose();
    timer?.cancel();
    _instance = null;
    super.dispose();
  }
}
