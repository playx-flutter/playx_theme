---
title: Theme modes
nav_order: 3
---

# Theme modes

`PlayxTheme` tracks a `ThemeMode` (`system`, `light`, `dark`) next to the current theme.

```dart
PlayxTheme.updateToLightMode();
PlayxTheme.updateToDarkMode();
PlayxTheme.updateToDeviceMode();               // follows the device from now on
PlayxTheme.updateByThemeMode(mode: ThemeMode.dark);
PlayxTheme.toggleMode();
```

In `ThemeMode.system`, the theme changes automatically when the device brightness changes.

## Which theme is used for a mode?

The first light/dark theme in the list, or the one you point at in the config:

```dart
PlayxThemeConfig(
  themes: [...],
  lightThemeIndex: 0,
  darkThemeIndex: 2,
)
```

If no theme matches a requested mode the call throws an `Exception` and nothing changes.

## Initial theme

Resolved in this order: `initialThemeIndex`, then `initialThemeMode`, then the device mode.

```dart
PlayxThemeConfig(
  themes: [...],
  initialThemeMode: ThemeMode.system,
)
```

When a theme was saved on a previous run, it wins over the initial theme.

## Reacting to mode changes

```dart
ValueListenableBuilder<ThemeMode>(
  valueListenable: PlayxTheme.themeModeNotifier,
  builder: (context, mode, _) => Text(mode.name),
)
```

`context.themeMode` reads the current mode but does not rebuild on its own.

## Previewing the next theme

```dart
final upcoming = PlayxTheme.nextTheme;   // XTheme that next() will switch to
final index = PlayxTheme.nextIndex;      // wraps to 0 after the last theme
```

## Updating the mode with a theme

Methods like `updateById` update the mode from the theme's brightness. Pass
`updateMode: false` to switch the theme but keep the current mode.
