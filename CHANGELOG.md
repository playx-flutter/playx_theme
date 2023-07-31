## 0.1.0 -0.1.1
- [Breaking change] : Refactor `AppTheme` to be `PlayxTheme`.
- [Breaking change] : Refactor `XTheme` theme property from `ThemeData` to `ThemeData Function( Locale locale)`
- Move `PlayxCore.boot()` to be called individually.


## 0.0.8 -0.0.9
- update packages

## 0.0.6 -0.0.7
- update packages
- Add `dispose` function to `AppTheme` to clear unused resources.


## 0.0.5
- [Breaking change] : Refactor `XThemeConfig` [nameBuilder] function to String [name]
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
