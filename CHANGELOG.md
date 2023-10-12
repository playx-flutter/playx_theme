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