import 'package:flutter/material.dart';

import '/src/config/config.dart';

/// This is base class for creating a custom colors for each theme.
/// Each theme can have its own colors that is configured in [XThemeConfig].
/// Each xTheme can have a class that extends this class to provide custom colors for each theme.
/// If you want to extend the colors that are defined in [XColors]
/// You can define another base class that extends [XColors] and adds more colors to it.
/// And Make Each Theme Color Scheme to extend the new Class.
/// You can access each theme color scheme like this:
/// ```dart
///  final colorScheme = PlayxTheme.colorScheme;
///  final primary = colorScheme.primary;
///  ```
class XColors {
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color outline;
  final Color outlineVariant;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;
  final Color shadow;
  final Color scrim;
  final Color surfaceTint;

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

  XColors.fromColorScheme({
    required ColorScheme scheme,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    Color? outlineVariant,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? shadow,
    Color? scrim,
    Color? surfaceTint,
  })  : primary = primary ?? scheme.primary,
        onPrimary = onPrimary ?? scheme.onPrimary,
        primaryContainer = primaryContainer ?? scheme.primaryContainer,
        onPrimaryContainer = onPrimaryContainer ?? scheme.onPrimaryContainer,
        secondary = secondary ?? scheme.secondary,
        onSecondary = onSecondary ?? scheme.onSecondary,
        secondaryContainer = secondaryContainer ?? scheme.secondaryContainer,
        onSecondaryContainer =
            onSecondaryContainer ?? scheme.onSecondaryContainer,
        tertiary = tertiary ?? scheme.tertiary,
        onTertiary = onTertiary ?? scheme.onTertiary,
        tertiaryContainer = tertiaryContainer ?? scheme.tertiaryContainer,
        onTertiaryContainer = onTertiaryContainer ?? scheme.onTertiaryContainer,
        error = error ?? scheme.error,
        onError = onError ?? scheme.onError,
        errorContainer = errorContainer ?? scheme.errorContainer,
        onErrorContainer = onErrorContainer ?? scheme.onErrorContainer,
        outline = outline ?? scheme.outline,
        outlineVariant = outlineVariant ?? scheme.outlineVariant,
        background = background ?? scheme.background,
        onBackground = onBackground ?? scheme.onBackground,
        surface = surface ?? scheme.surface,
        onSurface = onSurface ?? scheme.onSurface,
        surfaceVariant = surfaceVariant ?? scheme.surfaceVariant,
        onSurfaceVariant = onSurfaceVariant ?? scheme.onSurfaceVariant,
        inverseSurface = inverseSurface ?? scheme.inverseSurface,
        onInverseSurface = onInverseSurface ?? scheme.onInverseSurface,
        inversePrimary = inversePrimary ?? scheme.inversePrimary,
        shadow = shadow ?? scheme.shadow,
        scrim = scrim ?? scheme.scrim,
        surfaceTint = surfaceTint ?? scheme.primary;

  const XColors({
    this.primary = blueMain,
    this.onPrimary = white,
    this.primaryContainer = white,
    this.onPrimaryContainer = black,
    this.secondary = Colors.teal,
    this.onSecondary = white,
    this.secondaryContainer = white,
    this.onSecondaryContainer = black,
    this.tertiary = purpleMain,
    this.onTertiary = white,
    this.tertiaryContainer = white,
    this.onTertiaryContainer = black,
    this.error = red,
    this.onError = white,
    this.errorContainer = redLight,
    this.onErrorContainer = white,
    this.outline = black,
    this.outlineVariant = Colors.black12,
    this.background = white,
    this.onBackground = black,
    this.surface = white,
    this.onSurface = black,
    this.surfaceVariant = Colors.white12,
    this.onSurfaceVariant = Colors.black12,
    this.inverseSurface = black,
    this.onInverseSurface = white,
    this.inversePrimary = white,
    this.shadow = black,
    this.scrim = white,
    this.surfaceTint = white,
  });
}

class DefaultColors extends XColors {
  const DefaultColors();
}
