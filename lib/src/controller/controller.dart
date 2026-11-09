import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../playx_theme.dart';
import '../utils/animation_utils.dart';
import 'theme_persistence.dart';
import 'theme_resolver.dart';

/// XThemeController is responsible for managing and updating the app's theme,
/// including handling theme changes, animations, and theme persistence.
class XThemeController extends ValueNotifier<XTheme>
    with WidgetsBindingObserver {
  static const lastKnownIndexKey = ThemePersistence.indexKey;
  static const lastKnownThemeModeKey = ThemePersistence.modeKey;

  static XThemeController? _instance;

  /// Get the instance of the [XThemeController].
  /// Throws an exception if [boot] has not been called before accessing the instance.
  static XThemeController get instance {
    if (_instance == null) {
      throw Exception(
        'PlayxTheme is not initialized. Please call boot() before accessing PlayxTheme.',
      );
    }
    return _instance!;
  }

  /// The booted controller, or `null` if [boot] hasn't been called.
  static XThemeController? get maybeInstance => _instance;

  /// Disposes the booted controller (if any) and clears the singleton.
  static void disposeInstance() => _instance?.dispose();

  /// Theme configuration.
  final PlayxThemeConfig config;

  /// Default theme index.
  int initialIndex = -1;

  /// Where the selected theme index and mode are persisted.
  PlayxThemeStorage get storage =>
      config.storage ?? const PlayxPrefsThemeStorage();

  late final ThemePersistence _persistence = ThemePersistence(storage);

  /// The current theme being used.
  XTheme get theme => value;

  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier(
    ThemeMode.system,
  );

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
  XThemeController({XTheme? theme, required this.config})
    : super(theme ?? getInitialThemeByConfig(config)) {
    var initialThemeIdx = availableThemes.indexOf(
      theme ?? getInitialThemeByConfig(config),
    );
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
  static PlayxBaseLogger get logger {
    var logger = PlayxLogger.getLogger('PLAYX THEME');
    if (logger == null) {
      // The controller can be used without `PlayxTheme.boot`, so make sure
      // the logger exists.
      PlayxLogger.initLogger(name: 'PLAYX THEME', useColoredFormatter: true);
      logger = PlayxLogger.getLogger('PLAYX THEME');
    }
    return logger!;
  }

  // Info and warnings are only logged when `config.logThemeChanges` is on;
  // errors are always logged since an exception follows them.
  void _logInfo(String message) {
    if (config.logThemeChanges) logger.info(message);
  }

  void _logWarning(String message) {
    if (config.logThemeChanges) logger.warning(message);
  }

  void _logError(String message) => logger.error(message);

  /// Retrieves the optional explicitly set theme mode, or system by default.
  ThemeMode getInitialThemeMode() => ThemeResolver.initialMode(config);

  /// Retrieves the initial theme based on the configuration.
  XTheme getInitialTheme() => getInitialThemeByConfig(config);

  /// Helper to retrieve the initial theme using a configuration object before initialization.
  static XTheme getInitialThemeByConfig(PlayxThemeConfig config) =>
      ThemeResolver.initialTheme(config, deviceIsDark: isDeviceInDarkMode());

  /// Initializes the theme controller by loading the last saved theme index if applicable.
  Future<void> boot() async {
    _instance = this;
    final lastSavedIndex = config.saveTheme
        ? await getLastSavedIndexFromPrefs(
            migratePrefsToAsync: config.migratePrefsToAsyncPrefs,
          )
        : null;

    final lastSavedThemeModeString = config.saveTheme
        ? await _persistence.loadMode()
        : null;

    final resolved = ThemeResolver.resolveBoot(
      config,
      savedIndex: lastSavedIndex,
      savedMode: lastSavedThemeModeString,
      deviceIsDark: isDeviceInDarkMode(),
    );
    _themeModeNotifier.value = resolved.mode;
    value = resolved.theme;

    currentIndex = availableThemes.indexOf(value);
    initialIndex = currentIndex;

    WidgetsBinding.instance.addObserver(this);
    _logInfo(
      'Initialized with theme: ${value.id} at index: $currentIndex, mode: ${_themeModeNotifier.value.name}',
    );
  }

  XTheme? _getThemeForMode(bool isDark) =>
      ThemeResolver.themeForBrightness(config, isDark);

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (_themeModeNotifier.value == ThemeMode.system) {
      final currentTheme =
          _getThemeForMode(isDeviceInDarkMode()) ?? config.themes.first;
      _applyTheme(
        theme: currentTheme,
        index: availableThemes.indexOf(currentTheme),
        animate: false,
      );
    }
  }

  /// Retrieves the last saved theme index from preferences.
  ///
  /// If [migratePrefsToAsync] is true, preferences are migrated to asynchronous storage.
  Future<int?> getLastSavedIndexFromPrefs({
    bool migratePrefsToAsync = false,
  }) async {
    return _persistence.loadIndex(
      migrateLegacyPrefs: migratePrefsToAsync,
      fallbackIndex: initialIndex,
    );
  }

  /// Applies [theme] (at [index] in the available themes) to the app.
  ///
  /// If [mode] is given, the theme mode is changed to it together with the
  /// theme, so listeners never see a mode that doesn't match the theme.
  /// Everything that decides the final state (current index, what gets saved)
  /// happens synchronously when this is called, so concurrent calls resolve in
  /// call order: the last requested theme wins and is the last one persisted.
  Future<void> _applyTheme({
    required XTheme theme,
    required int index,
    ThemeMode? mode,
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (index < 0 || index >= availableThemes.length) {
      _logError('Index $index is out of range for available themes list.');
      throw RangeError(
        'The provided index is out of range of available themes list',
      );
    }
    final modeChanged = mode != null && mode != themeMode;
    final saves = <Future<void>>[
      if (config.saveTheme && modeChanged) _persistence.saveMode(mode),
    ];

    if (value == theme) {
      _logWarning('Theme is already set to ${theme.id}, no update needed.');
      if (modeChanged) _themeModeNotifier.value = mode;
      await Future.wait(saves);
      return;
    }

    _logInfo(
      'Updating theme from ${value.id} to ${theme.id} at index $index with animation enabled : $animate',
    );
    currentIndex = index;
    if (config.saveTheme) saves.add(_persistence.saveIndex(index));

    void applyMode() {
      if (modeChanged) _themeModeNotifier.value = mode;
    }

    if (animate && controller != null) {
      await animateTheme(
        theme: theme,
        controller: controller!,
        animation: animation,
        onThemeApplied: applyMode,
      );
    } else {
      value = theme;
      applyMode();
      if (forceUpdateNonAnimatedTheme) {
        _forceAppUpdate();
      }
    }
    await Future.wait(saves);
  }

  /// Switches to the theme for [mode] (light, dark or the device's mode) and
  /// sets the theme mode to it.
  ///
  /// Throws an [Exception] if no theme matches the mode.
  Future<void> _switchToMode(
    ThemeMode mode, {
    required PlayxThemeAnimation animation,
    required bool animate,
    required bool forceUpdateNonAnimatedTheme,
  }) async {
    final isDark = mode == ThemeMode.system
        ? isDeviceInDarkMode()
        : mode == ThemeMode.dark;
    final theme = _getThemeForMode(isDark);
    if (theme == null) {
      final message = switch (mode) {
        ThemeMode.light =>
          'Could not find any light theme in the available themes',
        ThemeMode.dark =>
          'Could not find any dark theme in the available themes',
        ThemeMode.system =>
          'Could not find any theme that matches the device mode',
      };
      _logError(message);
      throw Exception(message);
    }
    return _applyTheme(
      theme: theme,
      index: availableThemes.indexOf(theme),
      mode: mode,
      animation: animation,
      animate: animate,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
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

  /// The theme mode that matches [theme]'s brightness, or `null` when
  /// [updateMode] is false.
  ThemeMode? _modeFor(XTheme theme, bool updateMode) =>
      !updateMode ? null : (theme.isDark ? ThemeMode.dark : ThemeMode.light);

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
    final index = availableThemes.indexOf(theme);
    if (index < 0) {
      _logError('Theme ${theme.id} not found in available themes.');
      throw Exception('The provided theme is not in the available theme list');
    }
    return _applyTheme(
      theme: theme,
      index: index,
      mode: _modeFor(theme, updateMode),
      animation: animation,
      animate: animate,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// The index of the theme that [nextTheme] would switch to.
  ///
  /// Wraps around to `0` when the current theme is the last one.
  int get nextThemeIndex =>
      currentIndex >= config.themes.length - 1 ? 0 : currentIndex + 1;

  /// The theme that [nextTheme] would switch to.
  XTheme get nextThemeValue => config.themes[nextThemeIndex];

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
    return updateByIndex(
      nextThemeIndex,
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
      _logError('Index $index is out of range for available themes list.');
      throw RangeError(
        'The provided index is out of range of available themes list',
      );
    }
    final theme = availableThemes[index];
    return _applyTheme(
      theme: theme,
      index: index,
      mode: _modeFor(theme, updateMode),
      animation: animation,
      animate: animate,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
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
    final index = availableThemes.indexWhere((element) => element.id == id);
    if (index < 0) {
      _logError('Theme with id $id not found in available themes.');
      throw Exception('The provided id is not in the available themes list');
    }
    final theme = availableThemes[index];
    return _applyTheme(
      theme: theme,
      index: index,
      mode: _modeFor(theme, updateMode),
      animation: animation,
      animate: animate,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
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
  }) => _switchToMode(
    ThemeMode.light,
    animation: animation,
    animate: animate,
    forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
  );

  /// Update the theme to the first dark theme in supported themes
  /// (or uses `darkThemeIndex` if specified in config).
  /// If there is no dark theme, it will throw an exception.
  Future<void> updateToDarkMode({
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) => _switchToMode(
    ThemeMode.dark,
    animation: animation,
    animate: animate,
    forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
  );

  /// Update the theme to the first theme that matches the device mode
  /// (or uses `lightThemeIndex`/`darkThemeIndex` if specified in config).
  /// If there is no theme that matches the device mode, it will throw an exception.
  Future<void> updateToDeviceMode({
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) => _switchToMode(
    ThemeMode.system,
    animation: animation,
    animate: animate,
    forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
  );

  /// Update the theme to the first theme that matches the given mode.
  Future<void> updateByThemeMode({
    required ThemeMode mode,
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) => _switchToMode(
    mode,
    animation: animation,
    animate: animate,
    forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
  );

  /// Toggles between light and dark mode based on the current theme's brightness.
  ///
  /// If the current theme is dark it switches to the light mode, otherwise to
  /// the dark mode. Throws an [Exception] if the target mode has no theme.
  Future<void> toggleMode({
    PlayxThemeAnimation animation = const PlayxThemeAnimation.fade(),
    bool animate = true,
    bool forceUpdateNonAnimatedTheme = false,
  }) => _switchToMode(
    value.isDark ? ThemeMode.light : ThemeMode.dark,
    animation: animation,
    animate: animate,
    forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
  );

  /// Clear the last saved theme index and theme mode.
  ///
  /// Uses the storage of the booted controller, or the default one if
  /// PlayxTheme isn't booted yet.
  static Future<void> clearLastSavedTheme() async {
    final persistence =
        _instance?._persistence ??
        ThemePersistence(const PlayxPrefsThemeStorage());
    return persistence.clear();
  }

  /// Animate the theme change.
  ///
  /// [onThemeApplied] is called right after the new theme is set, before the
  /// animation runs.
  Future<void> animateTheme({
    required XTheme theme,
    required AnimationController controller,
    required PlayxThemeAnimation animation,
    VoidCallback? onThemeApplied,
  }) async {
    if (controller.isAnimating) {
      controller.reset();
      if (oldTheme != null) {
        value = oldTheme!;
      }
    }
    controller.duration = animation.duration;

    oldTheme = value;

    image = await AnimationUtils.saveScreenshot(
      previewContainer: previewContainer,
    );
    value = theme;
    onThemeApplied?.call();

    themeAnimation = animation;
    await animation.animate(controller: controller);

    // Notify listeners when the animation finishes.
    notifyListeners();
  }

  /// Update the theme animation controller.
  void updateThemeAnimationController(AnimationController? controller) {
    this.controller = controller;
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _themeModeNotifier.dispose();
    timer?.cancel();
    if (identical(_instance, this)) _instance = null;
    super.dispose();
  }
}
