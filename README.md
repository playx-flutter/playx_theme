
# Playx Theme
[![pub package](https://img.shields.io/pub/v/playx_theme.svg?color=1284C5)](https://pub.dev/packages/playx_theme)

Easily change and manage  current app theme with a lot of features like having custom colors for each theme and more.

# Features 🔥
- Create and manage app theme with the ability to easily change app theme.
- No need for `BuildContext` (you still can access the theme from the context if you need 😉)
- Create custom colors for each theme and easily access it like `PlayxTheme.colorScheme.primary`
- No need to store or load the last used theme by yourself .
- Custom utilities and widgets to help with app theming.


## Installation

in `pubspec.yaml` add these lines to `dependencies`

```yaml  
 playx_theme: ^0.2.3 
```   
## Usage
### - Boot the core

```dart    
 void main ()async{    
  WidgetsFlutterBinding.ensureInitialized();  
  
  /// * boot the core  
  await PlayxCore.bootCore();  
  
  /// boot the AppTheme  
  await PlayxTheme.boot();  
    
  /// run the app    
  runApp(const MyApp());    
}    
```   
### - Wrap Your App With `PlayXThemeBuilder`

```dart class MyApp extends StatelessWidget {    
  const MyApp({Key? key}) : super(key: key);    
    
  @override    
  Widget build(BuildContext context) {    
    final locale = Localizations.localeOf(context);  
    return PlayXThemeBuilder(    
      builder: (xTheme) {    
        return MaterialApp(    
          title: 'Flutter Demo',    
          theme: (locale)=> xTheme.theme(locale),    
          home: const MyHomePage(),    
        );    
      },    
    );    
  }    
}    
``` 
### Update App Theme

Use `PlayxTheme` to switch between themes.
As it provides some methods that demonstrate current app theme, it's index, name and id and allow you to easily update current app theme.

```dart     
    FloatingActionButton(    
        //Change App theme to the next theme in Theme Config.    
        onPressed: PlayxTheme.next,  //changes theme to next theme  
        child: Icon(Icons.next,    
        color: PlayxTheme.colorScheme.onBackground //color updates by theme.    
        ),    
      ),    
``` 
Here is a ``PlayxTheme `` methods :

| Method          | Description                                                  |  
|-----------------|:-------------------------------------------------------------|  
| next            | updates the app theme to the next theme.                     |  
| updateByIndex   | updates the app theme by the index.                          |  
| updateTo        | updates the app theme to a specific `XTheme`.                |  
| index           | Get current `XTheme` index.                                  |  
| xTheme          | Get current `XTheme`.                                        |   
| name            | Get current theme name.                                      |  
| id              | Get current theme id.                                        |  
| supportedThemes | Get current supported themes configured in `XThemeConfig`.   |  
| colors          | Get current `XTheme` color scheme.                           |  
| isDeviceInDarkMode   | Determines whether the device is in dark or light mode.  |  


### Customize Your Themes
To customize your themes, Create a class that extends ``XThemeConfig`` then overrides it's themes methods and provides it with all themes that your app needs.

For example:
```dart  
 class AppThemeConfig extends XThemeConfig {  
  @override  
  List<XTheme> get themes => [  
        XTheme(  
            id: 'light',  
            nameBuilder: () => 'Light',  
            theme: (locale) => ThemeData.light().copyWith(  
                textTheme: const TextTheme().apply(  
                    fontFamily:  
                    locale.languageCode == 'ar' ? 'Cairo' : 'Poppins')),
            cupertinoTheme:(locale) => const CupertinoThemeData(
              brightness: Brightness.light,
            ),
            colorScheme: LightColorScheme()),  
        XTheme(  
            id: 'dark',  
            nameBuilder: () => 'Dark',  
            theme: (locale) => ThemeData.dark().copyWith(  
                textTheme: const TextTheme().apply(  
                    fontFamily:  
                    locale.languageCode == 'ar' ? 'Cairo' : 'Poppins')),
            cupertinoTheme:(locale) => const CupertinoThemeData(
              brightness: Brightness.dark,
            ),
            colorScheme: DarkColorScheme()),  
      ];  
}  
```  
For each theme you need to pass an id , name and theme data and you can also provide colors for each theme.  
You can customize theme data based on each theme and your preferences.

### Customize theme's colors
We can create custom colors for each theme.

Each theme can have its own colors that is configured in `XThemeConfig`  as each `XTheme` have it's own colors.

To create custom colors , We can create for each theme a class that extends `XColors`  
and define it's color values like `primary` and `secondary`.  
For example :
```dart  
class LightColors extends XColors{  
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
```dart  
abstract class AppColors extends XColors{  
  ///Colors that needs to implemented for each theme.  
  Color get containerBackgroundColor;  
  
  ///Colors that needs to is used for each theme.  
  static const Color blue = Colors.blue;  
}  
```  

Then, We can make each theme color scheme class to extend  `AppColors `.    
For example:
```dart 
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

Now we can have access to colors that defined in both  `XColors`  and  `AppColors ` in each theme color scheme.

Then, We can access each theme color scheme like this:
 ```dart    
  final colorScheme = PlayxTheme.colorScheme as AppColors ;    
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
You can use the package wheteher you are using Material 2 or Material 3 as you can configure theme data for each theme to whether use Material 3 or not.

The package contatins multiple utilites and widgets that can help you with using Material 3 in your app.

As you can use `ImageTheme` widget that is themed by image content by providing image provider as it generates color scheme from image content.

Also you can blend two color schemes together and returns a new color scheme using `getBlendedColorScheme` method.
Also we have included [`flex_seed_scheme`](https://pub.dev/packages/flex_seed_scheme) package which is more flexible and powerful version of Flutter's ColorScheme.fromSeed.
Use multiple seed colors, custom chroma and tone mapping to enahce creating a color scheme for Material3.

## Playx:
Consider using our [Playx Package](https://pub.dev/packages/playx):    
Which comes prepackaged with Playx Theme with more features and is easy to use.



## See Also:
[playx_core](https://pub.dev/packages/playx_core) : core package of playx.

[Playx](https://pub.dev/packages/playx) : Playx eco system helps with redundant features , less code , more productivity , better organizing.