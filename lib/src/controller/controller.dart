import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../playx_theme.dart';
import '../utils/animation_utils.dart';

/// XThemeController used to handle all operations on themes like how to change theme, etc.
class XThemeController extends ValueNotifier<XTheme> {
  static const lastKnownIndexKey = 'playx.theme.last_known_index';

  static XThemeController? _instance;

  /// Get the instance of the [XThemeController].
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

  XTheme get theme => value;

  //Animation
  ui.Image? image;
  final previewContainer = GlobalKey();

  Timer? timer;
  ThemeSwitcherClipper clipper = const ThemeSwitcherCircleClipper();
  AnimationController? controller;
  PlayxThemeAnimationType animationType = PlayxThemeAnimationType.clipper;

  XTheme? oldTheme;

  bool isReversed = false;
  Offset switcherOffset = Offset.zero;

  XThemeController({
    XTheme? theme,
    required this.config,
  }) : super(theme ?? config.themes[config.initialThemeIndex]) {
    ///Default theme index.
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

  /// set up the base controller
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

  /// Update the theme to one of the theme list.
  /// The provided theme should be in the available themes list in [PlayxThemeConfig].
  /// If [animate] is true, it will animate the theme change.
  /// If [animate ]  is false, it will force the app to update the theme by building the whole widget tree.
  /// if [isReversed] is provided, It will play the animation based on reverse mode.
  /// if [isReversed] is not provided, It will decide to play the animation based on the current index.
  Future<void> _updateTheme({
    required XTheme theme,
    required int index,
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (value == theme) {
      return;
    }
    isReversed = animation?.type != PlayxThemeAnimationType.fade &&
        (animation?.isReversed ?? index < currentIndex);
    currentIndex = index;
    if (animate && controller != null) {
      await animateTheme(
          theme: theme,
          context: context,
          controller: controller!,
          animation: animation);
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

  /// Force the app to update the theme by building the whole widget tree.
  Future<void> _forceAppUpdate() async {
    return WidgetsFlutterBinding.ensureInitialized().performReassemble();
  }

  /// Force the app to update the theme by building the whole widget tree.
  void forceUpdateTheme() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _forceAppUpdate();
    });
  }

  /// Update the theme to one of the theme list.
  /// The provided theme should be in the available themes list in [PlayxThemeConfig].
  Future<void> updateTo(
    XTheme theme, {
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (!availableThemes.contains(theme)) {
      throw Exception('The provided theme is not in the available theme list');
    }
    return _updateTheme(
      theme: theme,
      index: availableThemes.indexOf(theme),
      animate: animate,
      context: context,
      animation: animation,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// switch the theme to the next in the list
  /// if there is no next theme, it will switch to the first one
  Future<void> nextTheme({
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    final isLastTheme = currentIndex == config.themes.length - 1;

    return updateByIndex(isLastTheme ? 0 : currentIndex + 1,
        animate: animate,
        context: context,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// update the theme to by index
  /// The index should be in the range of available themes list in [PlayxThemeConfig].
  /// if the index is out of range, it will throw a [RangeError] exception.
  Future<void> updateByIndex(
    int index, {
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (index < 0 || index >= availableThemes.length) {
      throw RangeError(
          'The provided index is out of range of available themes list');
    }
    return _updateTheme(
        theme: availableThemes[index],
        index: index,
        animate: animate,
        context: context,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// update the theme to by id.
  /// The [id] should be the id of one of the available themes list in [PlayxThemeConfig]/
  Future<void> updateById(
    String id, {
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) async {
    if (!availableThemes.any((element) => element.id == id)) {
      throw Exception('The provided id is not in the available themes list');
    }

    final index = availableThemes.indexWhere((element) => element.id == id);
    return _updateTheme(
        theme: availableThemes[index],
        index: index,
        animate: animate,
        context: context,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Returns Whether the device is currently in dark mode or not.
  static bool isDeviceInDarkMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }

  /// update the theme to the first light theme in supported themes.
  /// If there is no light theme, it will throw an exception.
  Future<void> updateToLightMode({
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    final theme = config.themes.firstWhereOrNull((element) => !element.isDark);
    if (theme == null) {
      throw Exception('Could not find any light theme in the available themes');
    }
    return updateTo(theme,
        animate: animate,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  ///Update the theme to the first dark theme in supported themes.
  ///If there is no dark theme, it will throw an exception.
  Future<void> updateToDarkMode({
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    final theme = config.themes.firstWhereOrNull((element) => element.isDark);
    if (theme == null) {
      throw Exception('Could not find any dark theme in the available themes');
    }
    return updateTo(
      theme,
      animate: animate,
      context: context,
      animation: animation,
      forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme,
    );
  }

  /// Update the theme to the first theme that matches the device mode.
  /// If there is no theme that matches the device mode, it will throw an exception.
  Future<void> updateToDeviceMode({
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    final theme = config.themes
        .firstWhereOrNull((element) => element.isDark == isDeviceInDarkMode());
    if (theme == null) {
      throw Exception('Could not find any theme that matches the device mode');
    }
    return updateTo(theme,
        animate: animate,
        context: context,
        animation: animation,
        forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
  }

  /// Update the theme to the first theme that matches the given mode.
  Future<void> updateByThemeMode({
    required ThemeMode mode,
    bool animate = true,
    BuildContext? context,
    PlayxThemeAnimation? animation,
    bool forceUpdateNonAnimatedTheme = false,
  }) {
    switch (mode) {
      case ThemeMode.system:
        return updateToDeviceMode(
            animate: animate,
            context: context,
            animation: animation,
            forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
      case ThemeMode.light:
        return updateToLightMode(
            animate: animate,
            context: context,
            animation: animation,
            forceUpdateNonAnimatedTheme: forceUpdateNonAnimatedTheme);
      case ThemeMode.dark:
        return updateToDarkMode(
            animate: animate,
            context: context,
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
    BuildContext? context,
    PlayxThemeAnimation? animation,
  }) async {
    if (controller.isAnimating) {
      controller.reset();
      if (oldTheme != null) {
        value = oldTheme!;
      }
    }
    if (animation?.duration != null) {
      controller.duration = animation!.duration;
    }

    clipper = animation?.clipper ?? const ThemeSwitcherCircleClipper();

    oldTheme = value;

    switcherOffset =
        AnimationUtils.getSwitcherCoordinates(context, animation?.offset);
    image =
        await AnimationUtils.saveScreenshot(previewContainer: previewContainer);
    value = theme;

    animationType = animation?.type ?? PlayxThemeAnimationType.clipper;
    await animationType.animate(
        controller: controller,
        isReversed: isReversed,
        onAnimationFinish: animation?.onAnimationFinish);

    // Notify listeners when the animation finishes.
    notifyListeners();
  }

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
