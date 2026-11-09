---
title: Custom colors and tokens
nav_order: 6
---

# Custom colors and tokens

## PlayxColors

Give each theme its own `PlayxColors`:

```dart
class LightColors extends PlayxColors {
  LightColors()
      : super.fromColorScheme(
          scheme: SeedColorScheme.fromSeeds(
            primaryKey: Colors.blue,
            brightness: Brightness.light,
          ),
        );
}

XTheme(id: 'light', name: 'Light', themeData: ..., colors: LightColors());
```

```dart
ColoredBox(color: context.playxColors.primary);
```

Extend `PlayxColors` with your own colors and expose them with an extension:

```dart
abstract class AppColors extends PlayxColors {
  AppColors({required super.primary});
  Color get cardBackground;
}

extension AppColorsX on BuildContext {
  AppColors get colors => playxColors as AppColors;
}
```

## ThemeExtension

Register `ThemeExtension`s in `ThemeData.extensions` so custom tokens switch (and
interpolate) with the theme:

```dart
XTheme(
  id: 'light',
  name: 'Light',
  themeData: ThemeData(extensions: const [AppSpacing(gap: 8)]),
);

final spacing = context.themeExtension<AppSpacing>();       // throws if missing
final maybe = context.maybeThemeExtension<AppSpacing>();    // null if missing
final fromTheme = PlayxTheme.currentTheme.extension<AppSpacing>();
```

## Locale-dependent themes

`XTheme.builder` takes a `themeBuilder` that receives the locale.

## Material 3 helpers

- `ImageTheme` builds a `ColorScheme` from an image.
- `getBlendedColorScheme` blends two color schemes.
- `flex_seed_scheme` is re-exported for multi-seed color schemes.
