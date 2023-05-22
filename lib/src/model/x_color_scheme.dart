import 'dart:ui';

import '/src/config/config.dart';

/// This is base class for creating a color scheme for each theme.
/// Each theme should have its own color scheme that is configured in [XThemeConfig].
/// Each theme color scheme extends this class to provide a color scheme for each theme.
/// If you want to extend the colors that are defined in [XColorScheme]
/// You can define another base class that extends [XColorScheme] and adds more colors to it.
/// And Make Each Theme Color Scheme to extend the new Class.
/// You can access each theme color scheme like this:
/// ```dart
///  final colorScheme = AppTheme.colorScheme;
///  final primary = colorScheme.primary;
///  ```
abstract class XColorScheme {
  Color get primary;
  Color get secondary;
  Color get background;
  Color get surface;
  Color get error;

  Color get onPrimary;
  Color get onSecondary;
  Color get onBackground;
  Color get onSurface;
  Color get onError;

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color darkGrey = Color(0xFF121212);

  static const Color blueMain = Color(0xFF1976d2);
  static const Color blueLight = Color(0xFF1976d2);
  static const Color blueDark = Color(0xFF1565c0);

  static const Color purpleMain = Color(0xFF9c27b0);
  static const Color purpleLight = Color(0xFFba68c8);
  static const Color purpleDark = Color(0xFF7b1fa2);

  static const Color blueLighterMain = Color(0xFF90caf9);
  static const Color blue200LighterLight = Color(0xFFe3f2fd);
  static const Color blue200LighterDark = Color(0xFF42a5f5);

  static const Color purpleLighterMain = Color(0xFFce93d8);
  static const Color purpleLighterLight = Color(0xFFf3e5f5);
  static const Color purpleLighterDark = Color(0xFFab47bc);

  static const Color blue = Color(0xFF054374);
  static const Color blueMid = Color(0xFF054477);

  static const Color yellow = Color(0xFFE6EE9C);
  static const Color pink = Color(0xFFCF8B8B);
  static const Color pinkDark = Color(0xFF8F6A6A);

  static const Color grey = Color(0xFFA9A9A9);
  static const Color greyLight = Color(0xFFA6A6A6);

  static const Color pinkLight = Color(0xFFFA2A70);

  static const Color orange = Color(0xFFd65a2e);

  static const Color red = Color(0xFFFF0200);
  static const Color redMain = Color(0xFFB00020);
  static const Color redLight = Color(0xFFCF6679);

  static const Color blackTransparent = Color(0x80054477);

  static const Color blueTransparent = Color(0x80032C4C);
}
