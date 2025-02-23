# Changelog

## 1.0.4
- Update packages
- Updates minimum supported SDK version to Flutter 3.24/Dart 3.5.

## 1.0.3
- Update packages

## 1.0.2
- Update packages

## 1.0.1
- Update packages
- Add test cases for the package
- refactor `_getCenterOffset` method in `AnimationUtils` to be a public `getCenterOffset` function.

## 1.0.0
> **Note**: This release contains breaking changes.

**New Features:**
- Added new animation types: fade, horizontal slide, vertical slide, and scale.
- Introduced `PlayxThemeAnimation` class to manage animations. This class includes:
    - Specific animation types are represented by subclasses such as `[PlayxThemeClipperAnimation]`, `[PlayxThemeFadeAnimation]`, `[PlayxThemeScaleAnimation]`, `[PlayxThemeHorizontalSlideAnimation]`, and `[PlayxThemeVerticalSlideAnimation]`.
    - Ability to reverse the animation.
    - Set the duration of the animation.
    - Handle specific animations settings and actions.

**Enhancements:**
- Migrated shared preferences to `SharedPreferencesAsync` for improved performance and async handling.
- Streamlined package by removing the GetX dependency, reducing the overall footprint.
- No need to call `PlayxCore.bootCore()` anymore. The package now initializes automatically.

**Breaking Changes:**
- **Theme Functions Update**: All `PlayxTheme` functions now use the `[PlayxThemeAnimation]` parameter to specify animations. The previous `animate` parameter has been removed. If `[animation]` is `null`, the theme change will be instant. If `[animation]` is provided, the theme change will be animated based on the animation type.
- **Shared Preferences Migration**: Migrated from `SharedPreferences` to `SharedPreferencesAsync`. If you're upgrading, set `migratePrefsToAsyncPrefs` to `true` in `PlayxThemeConfig` to ensure a smooth transition.
- **Theme Colors**: Removed `background`, `onBackground`, `surfaceVariant`colors as `surface`, `onSurface`, `surfaceContainerHighest` should be used instead based on latest material changes in flutter v3.22.0.

## 0.6.0
- Update `flex_seed_scheme` package to v3.0.0
- Update min flutter version to `3.22.0`
- Added new colors [`primaryFixed`, `primaryFixedDim`, `onPrimaryFixed`,`onPrimaryFixedVariant`, 
 `secondaryFixed`, `secondaryFixedDim`, `onSecondaryFixed`, `onSecondaryFixedVariant`,
  `tertiaryFixed`, `tertiaryFixedDim`, `onTertiaryFixed`, `onTertiaryFixedVariant`,
  `surfaceDim`, `surfaceBright`, `surfaceContainerLowest`, `surfaceContainerLow`, `surfaceContainer`, 
  `surfaceContainerHigh`, `surfaceContainerHighest`] based on latest material changes in flutter v3.22.0.
- Deprecated `background`, `onBackground`, `surfaceVariant`colors as `surface`, `onSurface`, `surfaceContainerHighest` should be used instead based on latest material changes in flutter v3.22.0.


## 0.5.0
> **Note**: This release contains breaking changes.

### New Features

#### PlayxThemeBuilder
PlayxThemeBuilder now uses an `InheritedWidget` to provide themes to its child widgets, enhancing theme management and widget rebuilding.

- **Theme Access**:
  - Use `XTheme.of(context)` or `context.xTheme` to get the current theme.
  - Use `PlayxColors.of(context)` or `context.playxColors` to get the current theme colors.

Use these methods to access theme or color information in your widgets. This ensures widgets are rebuilt correctly when the theme changes.

- **Legacy Access**:
  - You can still use `PlayxTheme.currentTheme` to access the current theme when you don't have a `BuildContext`. However, note that using `PlayxTheme.currentTheme` will not trigger a widget rebuild on theme changes.

### Breaking Changes
- **Class Renaming for Consistency**:
  - `XColors` is now `PlayxColors` to maintain consistency with the package name.
  - `XThemeConfig` is now `PlayxThemeConfig` for the same reason.


## 0.4.1 - 0.4.3

> Note: This release has breaking changes.

### New Features

- Introducing a unique theme animation feature to visualize theme changes within your app.
  - Simply add `PlayxThemeSwitchingArea` to the widget to animate the theme change.
  - Added new properties `child` and `duration` to `PlayxThemeBuilder` for customizing the child widget and animation duration.
  - Introduced `PlayxThemeSwitchingArea` widget for animating theme changes in specific areas of the app.
  - Added `PlayxThemeSwitcher` widget for animating theme changes starting from a specific widget.

- Updated `XThemeController` to use `ValueNotifier` instead of `GetxController` to reduce dependency on the `GetX` package.
- Added test cases for `XThemeController` and `PlayxTheme` to ensure the correct behavior of the theme controller and theme switcher.

### BREAKING Changes

- `XThemeConfig` is no longer an abstract class and can now be instantiated directly.

### Theme Updates

- Removed `theme` and `cupertinoTheme` properties.
- Introduced new properties `themeData` and `cupertinoThemeData` for specifying theme data and Cupertino theme data.
- Added `themeBuilder` and `cupertinoThemeBuilder` properties for customizing theme data based on the current locale.
- Modified `XTheme` constructor to require only `themeData`.
- Added `Xtheme.builder` for customizing theme data based on the current locale.

### PlayxTheme Updates

- Renamed `PlayxTheme.xTheme` to `PlayxTheme.currentTheme`.
- Added `PlayxTheme.themeData` getter to access current theme data.
- Updated theme update methods (`updateTo`, `updateByIndex`, `updateById`, `next`, `updateToDeviceMode`, `updateToLightMode`, `updateToDarkMode`, `updateByThemeMode`) to include more properties for controlling theme animation.
- Added `clearLastSavedTheme` method to clear the last saved theme from shared preferences.


## 0.3.2
- update packages

## 0.3.1
- update packages
- Bump minimum Dart version to 3.0.0


## 0.3.0
> Note: This release has breaking changes.
- update packages
- Rename `XThemeConfig` property `defaultThemeIndex` to `initialThemeIndex`.
- Add `saveTheme` to `XThemeConfig` to determine whether it should save the current theme index to shared preferences or not.
- Add `isDark` property to `Xtheme` to determine whether the theme is dark or not.
- Add `updateToLightMode` method to `PlayxTheme` which updates the theme to the first light theme in supported themes.
- Add `updateToDarkMode` method to `PlayxTheme` which updates the theme to the first dark theme in supported themes.
- Add `updateToDeviceMode` method to `PlayxTheme` which updates the theme to the first theme that matches the device mode.
- Add `updateByThemeMode` method to `PlayxTheme` which updates the theme to the first theme that matches the given mode.
- Add `initialTheme` property to `PlayxTheme` which is the initial theme that will be used when the app starts.


## 0.2.3
- update packages

## 0.2.2
- Added material 3 colors to `XColors` which can be configured through the app.
- Added an optional `fromColorScheme` to `XColors` to help with configuring material 3 style colors that can be used on the app.
- XDefaultThemeConfig now uses the default `XColors` instead of custom colors.


## 0.2.1
- Added an optional `cupertinoTheme` to `XTheme` to help with configuring cupertino app theme.

## 0.2.0
> Note: This release has breaking changes.
### New features
- PlayxTheme now has `isDeviceInDarkMode` to indicate whether the user device is in dark mode or not.
- XThemeConfig now has `defaultThemeIndex` to specify the default theme index that will be used first time as default theme.
- new `ImageTheme` widget which is a widget that is themed by image content by providing image provider to be used with Material3 themes.
- new utilities to be used like `getBlendedColorScheme` which blends two color schemes together and returns a new color scheme to be used with Material3 themes.
- Included [`flex_seed_scheme`](https://pub.dev/packages/flex_seed_scheme) package which is more flexible and powerful version of Flutter's ColorScheme.fromSeed and uses multiple seed colors, custom chroma and tone mapping to enahce creating a color scheme for Material3.

### BREAKING Changes
- `XColorScheme` was renamed to `XColors`.
- a Removed abstract colors like primary, secondary, background,surface, error ,onPrimary, Color get onSecondary, onBackground, onSurface, onError from `XColors`.
- `XTheme` colors property now have default value which is `DefaultColors`.



## 0.1.0 -0.1.1
- **BREAKING** : Refactor `AppTheme` to be `PlayxTheme`.
- **BREAKING** : Refactor `XTheme` theme property from `ThemeData` to `ThemeData Function( Locale locale)`
- Move `PlayxCore.boot()` to be called individually.


## 0.0.8 -0.0.9
- update packages

## 0.0.6 -0.0.7
- update packages
- Add `dispose` function to `AppTheme` to clear unused resources.


## 0.0.5
- **BREAKING** : Refactor `XThemeConfig` [nameBuilder] function to String [name]
- Added [updateById]: Updates theme using it's id.
- Added [forceUpdateTheme] variable to change theme functions which force the app to rebuild all widget after changing the theme. Useful when depending on colorScheme in your widgets.


## 0.0.4
- Add support for Dart 3.0.0 and Flutter 3.10
- Add new `XColorScheme` which is a new way to configure custom colors for each themes.  
  see Readme.md for more details about it.

## 0.0.2
- update packages

## 0.0.1+1
- fix typo

## 0.0.1

- initial release.