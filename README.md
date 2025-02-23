# Playx Theme

[![pub package](https://img.shields.io/pub/v/playx_theme.svg?color=1284C5)](https://pub.dev/packages/playx_theme) [![Build](https://github.com/playx-flutter/playx_theme/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/playx-flutter/playx_theme/actions/workflows/build.yml) <a href="https://codecov.io/gh/playx-flutter/playx_theme"><img src="https://codecov.io/gh/playx-flutter/playx_theme/branch/main/graph/badge.svg" alt="codecov"></a> <a href="https://github.com/playx-flutter/playx_theme/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

Playx Theme: Effortlessly control your app's visual style. Seamlessly switch themes, enjoy smooth animations, and tailor custom color schemes for each theme with ease in your Flutter projects## Features

- **Easy Theme Management**: Create and manage app themes effortlessly.
- **Smooth Transitions**: Switch between themes with unique transitions.
- **Custom Colors**: Define custom colors for each theme, e.g., `context.playxColors.primary`.
- **Automatic Theme Persistence**: Automatically store and load the last used theme.
- **Utility Widgets**: Utilize custom utilities and widgets for enhanced theming.

## Installation

Add the following line to your `dependencies` in `pubspec.yaml`:

```yaml  
playx_theme: ^1.0.4  
```  

## Usage

### Boot PlayxTheme

Initialize and boot the themes before running your app.

```dart  
void main() async {  
  WidgetsFlutterBinding.ensureInitialized();  
    
  // Boot the AppTheme  
  await PlayxTheme.boot(  
    config: PlayxThemeConfig(  
      themes: [  
        XTheme(  
          id: 'light',  
          name: 'Light',  
          themeData: ThemeData.light(),  
        ),  
        XTheme(  
          id: 'dark',  
          name: 'Dark',  
          themeData: ThemeData.dark(),  
        ),  
      ],  
    ),  
  );  
  
  // Run the app  
  runApp(const MyApp());  
}  
```  

### Wrap Your App with `PlayXThemeBuilder`

Use `PlayXThemeBuilder` to wrap your app and apply the themes.

```dart  
class MyApp extends StatelessWidget {  
  const MyApp({Key? key}) : super(key: key);  
  
  @override  
  Widget build(BuildContext context) {  
    return PlayXThemeBuilder(  
      builder: (context, theme) {  
        return MaterialApp(  
          title: 'Flutter Demo',  
          theme: theme.themeData,  
          home: const MyHomePage(),  
        );  
      },  
    );  
  }  
}  
```  

### Update App Theme

Switch between themes using `PlayxTheme`.

```dart  
FloatingActionButton(  
  onPressed: () {  
    PlayxTheme.updateById('dark');  
  },  
  child: Icon(  
    Icons.next,  
    color: PlayxTheme.colorScheme.onBackground,  
  ),  
)  
```  

### Accessing Current Theme

Retrieve the current theme information using context extensions.

```dart  
final themeId = context.xTheme.id;  
  
// Legacy Access  
final currentThemeId = PlayxTheme.currentTheme.id;  
final currentThemeData = PlayxTheme.currentThemeData;  
```  

### Available Methods

| Method              | Description                                                         |  
|---------------------|---------------------------------------------------------------------|  
| `index` | Returns current theme index.                                        |  
| `id` | Returns current theme id.                                           |  
| `name` | Returns current theme name.                                         |  
| `currentTheme` | Returns current `XTheme`.                                           |  
| `currentThemeData` | Returns current `ThemeData`.                                        |  
| `colors` | Returns current `XTheme` colors.                                    |  
| `initialTheme` | Returns start theme if provided.                                    |  
| `supportedThemes` | Returns list of supported themes configured in `PlayxThemeConfig`.  |  
| `next` | Updates the app theme to the next theme.                            |  
| `updateByIndex` | Updates the app theme by the index.                                 |  
| `updateTo` | Updates the app theme to a specific `XTheme`.                       |  
| `updateById` | Updates the app theme to a specific theme id.                       |  
| `isDeviceInDarkMode`| Determines whether the device is in dark or light mode.             |  
| `updateToLightMode` | Updates the app theme to the first light theme in supported themes. |  
| `updateToDarkMode` | Updates the app theme to the first dark theme in supported themes.  |  
| `updateToDeviceMode`| Updates the app theme to the device mode.                           |  
| `updateByThemeMode` | Updates the app theme to the first theme that matches the given mode|  
| `clearLastSavedTheme`| Clears the last saved theme.                                       |  


Here's the updated README section for animations in the Playx theme package, reflecting the new animation types and their implementations:

---

## Animation

The Playx theme package offers various animations to enhance the theme change experience in your app.

### PlayxThemeSwitchingArea

To show animations when changing themes, wrap the relevant screen with `PlayxThemeSwitchingArea`.

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayxThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Playx Theme Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => PlayxTheme.next(),
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```


### Theme Switching Animation Control

Customize theme switching animations using the `PlayxThemeAnimation` class and its subclasses. You can control various aspects of the animation.

#### PlayxThemeAnimation

The base class for theme animations provides common settings, including:

- **`isReversed`**: Reverses the animation direction.
- **`onAnimationFinish`**: Callback triggered when the animation finishes.
- **`duration`**: Duration of the animation.

#### PlayxThemeClipperAnimation

Defines clipping-based animations with custom clipper settings.

```dart
PlayxThemeAnimation.clipper(
  clipper: const ThemeSwitcherCircleClipper(),
  offset: Offset.zero,
)
```

You can customize theme switching animation with various parameters.

- **Starting Point**: Customize the animation's starting point with `offset` or `context`.
- **Custom Clipper**: Use a custom `clipper` like `ThemeSwitcherBoxClipper` or `ThemeSwitcherCircleClipper`.

You can use `PlayxThemeSwitcher` to switch themes with an animation starting from the triggering widget.

```dart
PlayxThemeSwitcher(
  builder: (ctx, theme) => FloatingActionButton(
    onPressed: () {
      PlayxTheme.next( 
	      animation:PlayxThemeAnimation.clipper(
			  clipper: const ThemeSwitcherCircleClipper(),
			  context: ctx,),
	      );
    },
    tooltip: 'Next Theme',
    child: Icon(
      Icons.add,
      color: context.colorScheme.onPrimary,
    ),
  ),
);
```
This will change the theme with  a circle clipping animation starting from the FloatingActionButton.


#### PlayxThemeFadeAnimation

Controls fade effects with adjustable opacity levels.

```dart
PlayxThemeAnimation.fade(
  begin: 0.0,
  end: 1.0,
)
```

#### PlayxThemeScaleAnimation

Handles scaling effects with adjustable scale values.

```dart
PlayxThemeAnimation.scale(
  begin: 0.5,
  end: 1.0,
)
```

#### PlayxThemeHorizontalSlideAnimation

Creates horizontal slide effects with start and end offsets.

```dart
PlayxThemeAnimation.horizontalSlide(
  beginOffset: Offset(-1.0, 0.0),
  endOffset: Offset(0.0, 0.0),
)
```

#### PlayxThemeVerticalSlideAnimation

Creates vertical slide effects with start and end offsets.

```dart
PlayxThemeAnimation.verticalSlide(
  beginOffset: Offset(0.0, -1.0),
  endOffset: Offset(0.0, 0.0),
)
```

## Customize Your Themes

Create a `PlayxThemeConfig` object and pass it to `PlayxTheme.boot()` to customize themes.

```dart  
final config = PlayxThemeConfig(  
  themes: [  
    XTheme(  
      id: 'light',  
      name: 'Light',  
      themeData: ThemeData(  
        brightness: Brightness.light,  
        colorScheme: lightColors.colorScheme,  
        useMaterial3: true,  
      ),  
      cupertinoThemeData: const CupertinoThemeData(  
        brightness: Brightness.light,  
      ),  
      colors: lightColors,  
    ),  
    XTheme.builder(  
      id: 'dark',  
      name: 'Dark',  
      initialTheme: ThemeData(  
        brightness: Brightness.dark,  
        colorScheme: darkColors.colorScheme,  
        useMaterial3: true,  
      ),  
      themeBuilder: (locale) => ThemeData(  
        brightness: Brightness.dark,  
        colorScheme: darkColors.colorScheme,  
        useMaterial3: true,  
      ),  
      cupertinoThemeBuilder: (locale) => const CupertinoThemeData(  
        brightness: Brightness.dark,  
      ),  
      isDark: true,  
      colors: darkColors,  
    ),  
  ],  
  initialThemeIndex: PlayxTheme.isDeviceInDarkMode() ? 1 : 0,  
);  
```  

### Customize Theme's Colors

Create custom colors for each theme by extending `PlayxColors`.

```dart  
class LightColors extends PlayxColors{  
  @override  
  Color get background => XColors.white;  
  
  @override  
  Color get error => XColors.red;  
  
  @override  
  Color get onBackground => XColors.black;  
}  
```  

Use custom colors in your widget tree.

```dart  
ColoredBox(color: context.playxColors.primary);  
```  

Extend `PlayxColors` to add more colors.

```dart  
abstract class AppColors extends PlayxColors{  
  Color get containerBackgroundColor;  
  static const Color blue = Colors.blue;  
}  
  
class LightColorScheme extends AppColors {  
  @override  
  Color get containerBackgroundColor => XColors.white;  
  
  @override  
  Color get background => XColors.white;  
  
  @override  
  Color get error => XColors.red;  
  
  @override  
  Color get onBackground => XColors.black;  
}  
```  

Access the extended colors.

```dart  
static AppColors of(BuildContext context) => context.playxColors as AppColors;  
  
final primary = AppColors.of(context).primary;  
  
extension AppColorsExtension on BuildContext {  
  AppColors get colors => AppColors.of(this);  
}  
  
ColoredBox(color: context.colors.primary);  
```  

## Material 3 Support

The package supports both Material 2 and Material 3. It includes

utilities and widgets to help with Material 3 integration, such as `ImageTheme` and `getBlendedColorScheme`. Additionally, it includes the `flex_seed_scheme` package for advanced color scheme creation.

## Reference & Documentation

- Check out the [documentation](https://pub.dev/documentation/playx_theme/latest/) for detailed information on how to integrate and utilize `playx_theme` in your Flutter applications.
- The theme switching animation is based on the [animated_theme_switcher](https://pub.dev/packages/animated_theme_switcher) package.

## Support and Contribution

For questions, issues, or feature requests, visit the [GitHub repository](https://github.com/playx-flutter/playx_theme). Contributions are welcome!

## See Also

- [Playx](https://pub.dev/packages/playx): Ecosystem for redundant features, less code, more productivity, better organizing.
- [Playx_core](https://pub.dev/packages/playx_core): Core of the Playx ecosystem, helping with app theming and localization.
- [Playx_localization](https://pub.dev/packages/playx_localization): Localization and internationalization for Flutter apps from the Playx ecosystem.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/playx-flutter/playx_core/blob/main/LICENSE) file for details.
