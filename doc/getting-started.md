---
title: Getting started
nav_order: 2
---

# Getting started

## 1. Boot PlayxTheme

Boot it once before `runApp`.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PlayxTheme.boot(
    config: PlayxThemeConfig(
      themes: [
        XTheme(id: 'light', name: 'Light', themeData: ThemeData.light()),
        XTheme(
          id: 'dark',
          name: 'Dark',
          themeData: ThemeData.dark(),
          isDark: true,
        ),
      ],
    ),
  );

  runApp(const MyApp());
}
```

{: .note }
Mark dark themes with `isDark: true`. Light/dark switching, system mode and
`toggleMode` rely on it.

## 2. Wrap your app

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayxThemeBuilder(
      builder: (context, xTheme) => MaterialApp(
        theme: xTheme.themeData,
        home: const HomePage(),
      ),
    );
  }
}
```

To use the switching animations, wrap your pages with
`PlayxThemeSwitchingArea` (see [Animations](animations)).

## 3. Switch themes

```dart
PlayxTheme.updateById('dark');
PlayxTheme.updateByIndex(1);
PlayxTheme.next();
PlayxTheme.toggleMode(); // light <-> dark
```

## 4. Read the current theme

```dart
final id = context.xTheme.id;
final data = context.themeData;
final isDark = context.isDarkMode;

// Without a BuildContext
PlayxTheme.currentTheme;
PlayxTheme.index;
```

## Reference

| Member | Description |
|---|---|
| `index`, `id`, `name` | Current theme index, id and name. |
| `currentTheme`, `currentThemeData`, `colors` | Current `XTheme`, its `ThemeData` and `PlayxColors`. |
| `initialTheme`, `supportedThemes` | First theme and all configured themes. |
| `next`, `nextIndex`, `nextTheme` | Switch to the next theme, or preview which one that is. |
| `updateByIndex`, `updateById`, `updateTo` | Switch to a specific theme. |
| `updateToLightMode`, `updateToDarkMode`, `updateToDeviceMode`, `updateByThemeMode` | Switch by mode. |
| `toggleMode` | Toggle light/dark from the current theme's brightness. |
| `themeMode`, `themeModeNotifier` | Current `ThemeMode` and a notifier to react to changes. |
| `isDeviceInDarkMode` | Whether the device is in dark mode. |
| `clearLastSavedTheme` | Forget the saved theme and mode. |
| `dispose` | Release the controller. |

Every switching method accepts `animation`, `animate` and
`forceUpdateNonAnimatedTheme`. The index/id/`updateTo`/`next` methods also take
`updateMode` (default `true`) to keep the `ThemeMode` in sync with the theme's brightness.
