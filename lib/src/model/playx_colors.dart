import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// Base class for defining custom colors for each theme.
///
/// Themes can have their own unique color schemes configured in [PlayxThemeConfig].
/// To provide custom colors for a specific theme, create a class that extends [PlayxColors].
///
/// If you need to expand the default color options provided by [PlayxColors],
/// you can create a new base class that extends [PlayxColors] and add additional color properties.
/// Then, each theme’s color scheme can extend this new class.
///
/// Accessing a theme's color scheme is straightforward:
///
/// ```dart
/// final colorScheme = PlayxTheme.colorScheme;
/// // or
/// // final colorScheme = context.playxColors;
/// final primary = colorScheme.primary;
/// ```
class PlayxColors {
  /// The primary color used throughout the theme.
  final Color primary;

  /// The color used for text and icons that are drawn on top of the [primary] color.
  final Color onPrimary;

  /// A color variant of the primary color used in containers and larger areas.
  final Color primaryContainer;

  /// The color used for text and icons that are drawn on top of the [primaryContainer] color.
  final Color onPrimaryContainer;

  /// A substitute for [primaryContainer] that maintains the same color in both dark and light themes.
  final Color primaryFixed;

  /// A more emphasized color than [primaryFixed] used for elements requiring additional prominence.
  final Color primaryFixedDim;

  /// The color used for text and icons that are drawn on top of elements with the [primaryFixed] color.
  final Color onPrimaryFixed;

  /// A lower-emphasis color option for text and icons compared to [onPrimaryFixed].
  final Color onPrimaryFixedVariant;

  /// The secondary color used to complement the primary color throughout the theme.
  final Color secondary;

  /// The color used for text and icons that are drawn on top of the [secondary] color.
  final Color onSecondary;

  /// A color variant of the secondary color used in containers and larger areas.
  final Color secondaryContainer;

  /// The color used for text and icons that are drawn on top of the [secondaryContainer] color.
  final Color onSecondaryContainer;

  /// A substitute for [secondaryContainer] that maintains the same color in both dark and light themes.
  final Color secondaryFixed;

  /// A more emphasized color than [secondaryFixed] used for elements requiring additional prominence.
  final Color secondaryFixedDim;

  /// The color used for text and icons that are drawn on top of elements with the [secondaryFixed] color.
  final Color onSecondaryFixed;

  /// A lower-emphasis color option for text and icons compared to [onSecondaryFixed].
  final Color onSecondaryFixedVariant;

  /// The tertiary color used as an accent in the theme.
  final Color tertiary;

  /// The color used for text and icons that are drawn on top of the [tertiary] color.
  final Color onTertiary;

  /// A color variant of the tertiary color used in containers and larger areas.
  final Color tertiaryContainer;

  /// The color used for text and icons that are drawn on top of the [tertiaryContainer] color.
  final Color onTertiaryContainer;

  /// A substitute for [tertiaryContainer] that maintains the same color in both dark and light themes.
  final Color tertiaryFixed;

  /// A more emphasized color than [tertiaryFixed] used for elements requiring additional prominence.
  final Color tertiaryFixedDim;

  /// The color used for text and icons that are drawn on top of elements with the [tertiaryFixed] color.
  final Color onTertiaryFixed;

  /// A lower-emphasis color option for text and icons compared to [onTertiaryFixed].
  final Color onTertiaryFixedVariant;

  /// The color used to indicate errors, typically used for warnings and error states.
  final Color error;

  /// The color used for text and icons that are drawn on top of the [error] color.
  final Color onError;

  /// A color variant used for containers and areas indicating error states.
  final Color errorContainer;

  /// The color used for text and icons that are drawn on top of the [errorContainer] color.
  final Color onErrorContainer;

  /// The color used for outlines of elements, providing a subtle border.
  final Color outline;

  /// A variant of [outline] with a different emphasis.
  final Color outlineVariant;

  /// The primary background color used in the theme.
  final Color surface;

  /// The color used for text and icons that are drawn on top of the [surface] color.
  final Color onSurface;

  /// A variant of [onSurface] that is more legible when drawn on [surfaceContainerHighest].
  final Color onSurfaceVariant;

  /// A color that's always the darkest in both dark and light themes, providing contrast on the [surface].
  final Color surfaceDim;

  /// A color that's always the lightest in both dark and light themes, providing contrast on the [surface].
  final Color surfaceBright;

  /// A surface container color with the lightest tone and the least emphasis relative to the surface.
  final Color surfaceContainerLowest;

  /// A surface container color with a lighter tone that creates less emphasis than [surfaceContainer] but more emphasis than [surfaceContainerLowest].
  final Color surfaceContainerLow;

  /// A recommended color role for a distinct area within the surface.
  /// Surface container colors include [surfaceContainerLowest], [surfaceContainerLow], [surfaceContainer], [surfaceContainerHigh], and [surfaceContainerHighest].
  final Color surfaceContainer;

  /// A surface container color with a darker tone, used to create more emphasis than [surfaceContainer] but less than [surfaceContainerHighest].
  final Color surfaceContainerHigh;

  /// The surface container color with the darkest tone, used to create the most emphasis against the surface.
  final Color surfaceContainerHighest;

  /// The inverse of the [surface] color, typically used for contrast in areas where the surface is the primary background.
  final Color inverseSurface;

  /// The color used for text and icons that are drawn on top of the [inverseSurface] color.
  final Color onInverseSurface;

  /// The color used to highlight elements against the inverse of the [primary] color.
  final Color inversePrimary;

  /// The color used to create shadows, providing depth to the UI.
  final Color shadow;

  /// The color used to obscure the content beneath overlays, such as modals.
  final Color scrim;

  /// The color used to tint surfaces, providing a subtle effect to emphasize the surface tone.
  final Color surfaceTint;
  //Deprecated
  @Deprecated('Use surface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.'
      ' It will be removed in the next releases.'
      'You can still expand the colors of the theme by extending the PlayxColors class.')
  final Color background;
  @Deprecated('Use onSurface instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.'
      ' It will be removed in the next releases.'
      'You can still expand the colors of the theme by extending the PlayxColors class.')
  final Color onBackground;
  @Deprecated('Use surfaceVariant instead. '
      'This feature was deprecated after v3.18.0-0.1.pre.'
      ' It will be removed in the next releases.'
      'You can still expand the colors of the theme by extending the PlayxColors class.')
  final Color surfaceVariant;

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

  PlayxColors.fromColorScheme({
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
    Color? surface,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? shadow,
    Color? scrim,
    Color? surfaceTint,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    @Deprecated('Use surface instead. '
        'This feature was deprecated after v3.18.0-0.1.pre.'
        ' It will be removed in the next releases.')
    Color? background,
    @Deprecated('Use onSurface instead. '
        'This feature was deprecated after v3.18.0-0.1.pre.'
        ' It will be removed in the next releases.')
    Color? onBackground,
    @Deprecated('Use surfaceContainerHighest instead. '
        'This feature was deprecated after v3.18.0-0.1.pre.'
        ' It will be removed in the next releases.')
    Color? surfaceVariant,
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
        surface = surface ?? scheme.surface,
        onSurface = onSurface ?? scheme.onSurface,
        onSurfaceVariant = onSurfaceVariant ?? scheme.onSurfaceVariant,
        inverseSurface = inverseSurface ?? scheme.inverseSurface,
        onInverseSurface = onInverseSurface ?? scheme.onInverseSurface,
        inversePrimary = inversePrimary ?? scheme.inversePrimary,
        shadow = shadow ?? scheme.shadow,
        scrim = scrim ?? scheme.scrim,
        surfaceTint = surfaceTint ?? scheme.primary,
        primaryFixed = primaryFixed ?? scheme.primaryFixed,
        primaryFixedDim = primaryFixedDim ?? scheme.primaryFixedDim,
        onPrimaryFixed = onPrimaryFixed ?? scheme.onPrimaryFixed,
        onPrimaryFixedVariant =
            onPrimaryFixedVariant ?? scheme.onPrimaryFixedVariant,
        secondaryFixed = secondaryFixed ?? scheme.secondaryFixed,
        secondaryFixedDim = secondaryFixedDim ?? scheme.secondaryFixedDim,
        onSecondaryFixed = onSecondaryFixed ?? scheme.onSecondaryFixed,
        onSecondaryFixedVariant =
            onSecondaryFixedVariant ?? scheme.onSecondaryFixedVariant,
        tertiaryFixed = tertiaryFixed ?? scheme.tertiaryFixed,
        tertiaryFixedDim = tertiaryFixedDim ?? scheme.tertiaryFixedDim,
        onTertiaryFixed = onTertiaryFixed ?? scheme.onTertiaryFixed,
        onTertiaryFixedVariant =
            onTertiaryFixedVariant ?? scheme.onTertiaryFixedVariant,
        surfaceDim = surfaceDim ?? scheme.surfaceDim,
        surfaceBright = surfaceBright ?? scheme.surfaceBright,
        surfaceContainerLowest =
            surfaceContainerLowest ?? scheme.surfaceContainerLowest,
        surfaceContainerLow = surfaceContainerLow ?? scheme.surfaceContainerLow,
        surfaceContainer = surfaceContainer ?? scheme.surfaceContainer,
        surfaceContainerHigh =
            surfaceContainerHigh ?? scheme.surfaceContainerHigh,
        surfaceContainerHighest =
            surfaceContainerHighest ?? scheme.surfaceContainerHighest,
        background = background ?? scheme.surface,
        onBackground = onBackground ?? scheme.onSurface,
        surfaceVariant = surfaceVariant ?? scheme.surfaceContainerHigh;

  const PlayxColors({
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
    this.primaryFixed = blueMain,
    this.primaryFixedDim = blueLight,
    this.onPrimaryFixed = white,
    this.onPrimaryFixedVariant = Colors.white70,
    this.secondaryFixed = purpleMain,
    this.secondaryFixedDim = purpleLight,
    this.onSecondaryFixed = white,
    this.onSecondaryFixedVariant = Colors.white70,
    this.tertiaryFixed = yellow,
    this.tertiaryFixedDim = yellow,
    this.onTertiaryFixed = white,
    this.onTertiaryFixedVariant = Colors.white70,
    this.surfaceDim = Colors.black12,
    this.surfaceBright = Colors.white,
    this.surfaceContainerLowest = Colors.white12,
    this.surfaceContainerLow = Colors.white24,
    this.surfaceContainer = Colors.white30,
    this.surfaceContainerHigh = Colors.white38,
    this.surfaceContainerHighest = Colors.white54,
  });

  static PlayxColors of(BuildContext context) {
    return XTheme.of(context).colors;
  }

  static PlayxColors? maybeOf(BuildContext context) {
    return XTheme.maybeOf(context)?.colors;
  }
}

class DefaultColors extends PlayxColors {
  const DefaultColors();
}
