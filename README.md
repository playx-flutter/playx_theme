
# Playx Theme

[![pub package](https://img.shields.io/pub/v/playx_theme.svg?color=1284C5)](https://pub.dev/packages/playx_theme)   [![Build](https://github.com/playx-flutter/playx_theme/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/playx-flutter/playx_theme/actions/workflows/build.yml) <a href="https://codecov.io/gh/playx-flutter/playx_theme"><img src="https://codecov.io/gh/playx-flutter/playx_theme/branch/main/graph/badge.svg" alt="codecov"></a> <a href="https://github.com/playx-flutter/playx_theme/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>

Playx Theme is a Flutter package that provides a simple and easy way to manage app theming and theme switching with unique animation .

# Features
- Create and manage app theme with the ability to easily change app theme.
- Switch between themes with unique transition.
- Create custom colors for each theme and easily access it like `PlayxTheme.colorScheme.primary`
- No need to store or load the last used theme by yourself .
- Custom utilities and widgets to help with app theming.

## Installation

in `pubspec.yaml` add these lines to `dependencies`

```yaml    
 playx_theme: ^0.4.1
```   
## Usage

- Boot the core

  ```dart      
   void main() async {  
    WidgetsFlutterBinding.ensureInitialized();  
    
    /// * boot the core    
    await PlayxCore.bootCore();  
    
    /// boot the AppTheme    
    await PlayxTheme.boot();  
    
    /// run the app      
    runApp(const MyApp());  
  } 
  ```   
- Wrap Your App With `PlayXThemeBuilder`

  ```dart  
   class MyApp extends StatelessWidget {  
    const MyApp({Key? key}) : super(key: key);  
    
    @override  
    Widget build(BuildContext context) {  
      final locale = Localizations.localeOf(context);  
      return PlayXThemeBuilder(  
        builder: (xTheme) {  
          return MaterialApp(  
            title: 'Flutter Demo',  
            theme: (locale) => xTheme.theme(locale),  
            home: const MyHomePage(),  
          );  
        },  
      );  
    }  
  } 
  ```   
### Update App Theme

Use `PlayxTheme` to switch between themes.  
As it provides some methods that demonstrate current app theme, it's index, name and id and allow  
you to easily update current app theme.

```dart       
    FloatingActionButton  (  
	//Change App theme to the next theme in Theme Config.      
		onPressed: PlayxTheme.next, //changes theme to next theme    
		child: Icon(Icons.next,  
			color: PlayxTheme.colorScheme.onBackground //color updates by 	theme.      
		),  
	)     
```  

| Method              | Description                                                          |    
|---------------------|:---------------------------------------------------------------------|    
| index               | Returns current theme index.                                         |  
| id                  | Returns current theme id.                                            |  
| name                | Returns current theme name.                                          |  
| currentTheme        | Returns current `XTheme`.                                            |  
| currentThemeData    | Returns current `ThemeData`.                                         |  
| colors              | Returns current `XTheme` colors.                                     |  
| initialTheme        | Returns Start theme if provided.                                     |  
| supportedThemes     | Returns list of supported themes configured in `XThemeConfig`.       |  
| next                | updates the app theme to the next theme.                             |    
| updateByIndex       | updates the app theme by the index.                                  |    
| updateTo            | updates the app theme to a specific `XTheme`.                        |    
| updateById          | updates the app theme to a specific theme id.                        |  
| isDeviceInDarkMode  | Determines whether the device is in dark or light mode.              |    
| updateToLightMode   | Updates the app theme to the first light theme in supported themes.  |  
| updateToDarkMode    | Updates the app theme to the first dark theme in supported themes.   |  
| updateToDeviceMode  | Updates the app theme to the device mode.                            |  
| updateByThemeMode   | Updates the app theme to the first theme that matches the given mode |  
| clearLastSavedTheme | Clears the last saved theme.                                         |  

### Animation

The package provides a unique animation for changing the app theme by providing unique transiction  
between theme switching.

#### PlayxThemeSwitchingArea

Wrap the screen where you want to make them switch with `PlayxThemeSwitchingArea` widget, as it has  
shown in the following example:

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
                  const Text(  
                    'You have pushed the button this many times:',  
                  ),  
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
when you change theme, the widget will animate the theme change starting form the center of the screen.
#### PlayxThemeSwitcher

You can use `PlayxThemeSwitcher` widget to switch between themes with animation starting from the  
widget that triggers the theme change.  
which gives you access to the current theme and widget context which we use to change the theme from this widget.


```dart
  PlayxThemeSwitcher(  
    builder: (ctx, theme) => FloatingActionButton(  
        onPressed: () {  
	        PlayxTheme.next(context: ctx);  
        },  
	    tooltip: 'Next Theme',  
			child: Icon(  
		    Icons.add,  
		     color: context.colorScheme.onPrimary,  
		    ),  
	  ),  
  );  
```  

when you change theme, the widget will animate the theme change starting form the widget that triggers the theme change.

#### Control Theme Switching Animation
By default, the package updates the app theme with an animation. This animation can be customized using various parameters:

- **Animate**: By default, theme switching includes animation, which can be disabled using the `animate` parameter. Setting `animate` to `false` will switch themes instantly without animation.

- **Starting Point**: The animation's starting point can be customized using the `offset` parameter or automatically set to the widget's position using the `context` parameter.
  - If both `offset` and `context` are provided, `offset` takes precedence.
  - If neither `offset` nor `context` is provided, the animation starts from the center of the screen.

- **Animation Direction**: The direction of the animation can be controlled using the `isReversed` parameter.
  - If provided, the animation will reverse based on its value;
  - otherwise, it will be determined by the current theme index.

- **Custom Clipper**: Optionally, a custom `clipper` can be provided to clip the animation. Accepted values are `ThemeSwitcherBoxClipper` or `ThemeSwitcherCircleClipper`.

- **Force Update**: If animation is disabled using `animate`, `forceUpdateNonAnimatedTheme` can be used to force update the theme without animation.

For example, to use a custom clipper and custom offset, you can use the following code:

```dart  
    PlayxTheme.next(  
        context: ctx,  
        clipper: const ThemeSwitcherBoxClipper(),  
        offset: Offset.zero,   
      );  
```  
These parameters provide flexibility in controlling the animation of theme switching within your app.


### Customize Your Themes

To customize your themes, you need to create a `XThemeConfig` object and pass it to `PlayxTheme.boot()`.  
`XThemeConfig` contains a list of `XTheme` objects that represent each theme in your app.  
For each theme you need to pass an id , name and theme data and you can also provide colors for each theme.    
You can customize theme data based on each theme and your preferences.

For example:

```dart    
   final config = XThemeConfig(  
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
          colors: lightColors),  
      XTheme.builder(  
          id: 'dark',  
          name: 'Dark',  
          initialTheme: ThemeData(  
            brightness: Brightness.dark,  
            colorScheme: darkColors.colorScheme,  
            useMaterial3: true,  
          ),  
          /// We can use builder to specify different theme data for each locale.  
          themeBuilder: (locale) => ThemeData(  
            brightness: Brightness.dark,  
            colorScheme: darkColors.colorScheme,  
            useMaterial3: true,  
          ),  
          cupertinoThemeBuilder: (locale) => const CupertinoThemeData(  
            brightness: Brightness.dark,  
          ),  
          isDark: true,  
          colors: darkColors),  
    ],  
    initialThemeIndex: PlayxTheme.isDeviceInDarkMode() ? 1 : 0,  
  );  
```  
### Customize theme's colors

We can create custom colors for each theme.

Each theme can have its own colors that is configured in `XThemeConfig`  as each `XTheme` have it's  
own colors.

To create custom colors , We can create for each theme a class that extends `XColors`    
and define it's color values like `primary` and `secondary`.    
For example :

```dart class LightColors extends XColors {  
  @override  
  Color get background => XColors.white;  
  
  @override  
  Color get error => XColors.red;  
  
  @override  
  Color get onBackground => XColors.black;  
}    
```   
If you want to extend the colors that are defined in `XColors`    
You can define another base class that extends `XColors` and adds more colors to it.      
For example:

```dart abstract class AppColors extends XColors {  
  ///Colors that needs to implemented for each theme.    
  Color get containerBackgroundColor;  
  
  ///Colors that needs to is used for each theme.    
  static const Color blue = Colors.blue;  
} 
```   
Then, We can make each theme color scheme class to extend  `AppColors `.      
For example:

```dart class LightColorScheme extends AppColors {  
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
Now we can have access to colors that defined in both  `XColors` and  `AppColors ` in each theme  
color scheme.

Then, We can access each theme color scheme like this:

 ```dart   
final colorScheme = PlayxTheme.colorScheme as AppColors;  
  
final primary = colorScheme.primary;      
 ```   
and use it in widget like this :

 ```dart    
  @override  
Widget build(BuildContext context) {  
  return ColoredBox(color: colorScheme.primary);  
}    
```   
## Material 3:

You can use the package wheteher you are using Material 2 or Material 3 as you can configure theme  
data for each theme to whether use Material 3 or not.

The package contatins multiple utilites and widgets that can help you with using Material 3 in your  
app.

As you can use `ImageTheme` widget that is themed by image content by providing image provider as it  
generates color scheme from image content.

Also you can blend two color schemes together and returns a new color scheme  
using `getBlendedColorScheme` method.  
Also we have included [`flex_seed_scheme`](https://pub.dev/packages/flex_seed_scheme) package which  
is more flexible and powerful version of Flutter's ColorScheme.fromSeed.  
Use multiple seed colors, custom chroma and tone mapping to enahce creating a color scheme for  
Material3.

## Reference & Documentation

- Check out the [documentation](https://pub.dev/documentation/playx_theme/latest/) for detailed  information on how to integrate and utilize playx_theme in your Flutter applications.

- The theme switching animation is based on the [animated_theme_switcher](https://pub.dev/packages/animated_theme_switcher) package.


## Support and Contribution

For any questions, issues, or feature requests, please visit the GitHub repository  
of [playx_theme](https://github.com/playx-flutter/playx_theme). Contributions are welcome!

## See Also:

[Playx](https://pub.dev/packages/playx) : Playx eco system helps with redundant features , less  
code , more productivity , better organizing.

[Playx_core](https://pub.dev/packages/playx_core) : Core of playx eco system which helps with app  
theming and app localization.

[Playx_localization](https://pub.dev/packages/playx_localization) : Localization and  
internationalization for flutter apps from playx eco system

## License

This project is licensed under the MIT License - see  
the [LICENSE](https://github.com/playx-flutter/playx_core/blob/main/LICENSE) file for details