---
title: Animations
nav_order: 4
---

# Animations

Pass a `PlayxThemeAnimation` to any switching method. The default is `PlayxThemeAnimation.fade()`.
Use `animate: false` to switch instantly.

Wrap the part of your UI that should animate with `PlayxThemeSwitchingArea`:

```dart
MaterialApp(
  theme: xTheme.themeData,
  home: PlayxThemeSwitchingArea(child: const HomePage()),
)
```

Common options on every animation: `duration` (default 300 ms), `onAnimationFinish`
and, where supported, `isReversed`.

| Animation | Effect |
|---|---|
| `PlayxThemeAnimation.fade(begin, end)` | Cross-fade between the old and new UI. |
| `PlayxThemeAnimation.scale(begin, end)` | Scale transition. |
| `PlayxThemeAnimation.horizontalSlide(beginOffset, endOffset)` | Slide sideways. |
| `PlayxThemeAnimation.verticalSlide(beginOffset, endOffset)` | Slide up or down. |
| `PlayxThemeAnimation.clipper(clipper, offset, context)` | Reveal with a circle or box from a point. |
| `PlayxThemeAnimation.lerp(curve)` | Interpolate `ThemeData` in place, no screenshot. |

## Reveal from a button

```dart
PlayxThemeSwitcher(
  builder: (ctx, theme) => FloatingActionButton(
    onPressed: () => PlayxTheme.next(
      animation: PlayxThemeAnimation.clipper(
        clipper: const ThemeSwitcherCircleClipper(),
        context: ctx,
      ),
    ),
    child: const Icon(Icons.brightness_6),
  ),
)
```

`ThemeSwitcherBoxClipper` gives a rectangular reveal.

## Interpolating the theme

```dart
PlayxTheme.next(animation: const PlayxThemeAnimation.lerp(curve: Curves.easeInOut));
```

Colors, text styles and other `ThemeData` values transition smoothly instead of
cross-fading screenshots. It needs `PlayxThemeSwitchingArea`.

## Waiting for the end

The future returned by the switching methods completes when the animation has finished.
