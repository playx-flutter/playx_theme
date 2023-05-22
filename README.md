# Playx Theme
Multi theme features for flutter apps from playx eco system.

# Features 🔥
- Create and mange app theme with the ability to easily change app theme.
- No need for `BuildContext` (you still can access the theme from the context if you need 😉)
- Create custom colors for each theme and easily access it like `AppTheme.colorScheme.primary`
- Works out of the box.
- No need to store or load the last used theme by your self

## Playx:
Consider using our [Playx Package](https://pub.dev/packages/playx):  
Which comes prepackaged with Playx Theme with more features and is easy to use.

## Installation

in `pubspec.yaml` add these lines to `dependencies`

```yaml
 playx_theme: ^0.0.4  
```   

## Usage
### - Boot the core

```dart  
 void main ()async{  
 WidgetsFlutterBinding.ensureInitialized();  
   
  /// boot the theme  
  /// you can provide `XThemeConfig` to add your custom themes  
  await AppTheme.boot();  
  
  /// run the real app  
  runApp(const MyApp());  
}  
```  

###  - Wrap Your App With `PlayXThemeBuilder`

```dart  
class MyApp extends StatelessWidget {  
  const MyApp({Key? key}) : super(key: key);  
  
  @override  
  Widget build(BuildContext context) {  
    return PlayXThemeBuilder(  
      builder: (xTheme) {  
        return MaterialApp(  
          title: 'Flutter Demo',  
          theme: xTheme.theme,  
          home: const MyHomePage(),  
        );  
      },  
    );  
  }  
}  
```  
### Update App Theme

#### Use `AppTheme` facade to switch between themes
With `AppTheme` you will have access to current app theme, it's index, name and id.

```dart   
    FloatingActionButton(  
        //Change App theme to the next theme in Theme Config.  
        onPressed: AppTheme.next,  //changes theme to next theme
        child: Icon(Icons.next,  
        color: AppTheme.colorScheme.onBackground //color updates by theme.  
        ),  
      ),  
```  
Here is a ``AppTheme `` methods :
| Method           | Description                                                |
| -----------      | :--------------------------------------------------------  |
| next             | updates the app theme to the next theme.                   |
| updateByIndex    | updates the app theme by the index.                        |
| updateTo         | updates the app theme to a specific `XTheme`.              |
| index            | Get current `XTheme` index.                                |
| xTheme           | Get current `XTheme`.                                      |
| name             | Get current theme name.                                    |
| id               | Get current theme id.                                      |
| supportedThemes  | Get current supported themes configured in `XThemeConfig`. |
| colorScheme      | Get current `XTheme` color scheme.                         |


### Customize Your Themes
Create a class that extends ``XThemeConfig`` then overrides it's themes method and provides it with all themes that your app needs.

For example:
```dart
 class AppThemeConfig extends XThemeConfig {
  @override
  List<XTheme> get themes => [
        XTheme(
            id: 'light',
            nameBuilder: () => 'Light',
            theme: ThemeData.light(),
            colorScheme: LightColorScheme()),
        XTheme(
            id: 'dark',
            nameBuilder: () => 'Dark',
            theme: ThemeData.dark(),
            colorScheme: DarkColorScheme()),
      ];
}
```
For each theme you need to pass an id , name , theme data and color scheme  for each theme.
You can customize theme data based on each theme and your preferences.

### Customize theme's color scheme
We can create custom color scheme for each theme.
Each theme can have its own color scheme that is configured in `XThemeConfig`
As we each `XTheme` have it's own color scheme.
To create custom color scheme, We can create for each theme a class that extends `XColorScheme`
and define it's color values like `primary` and `secondary`.
For example :
```dart
class LightColorScheme extends XColorScheme{
  @override
  Color get background => XColorScheme.white;

  @override
  Color get error => XColorScheme.red;

  @override
  Color get onBackground => XColorScheme.black;
  }
  ```

If you want to extend the colors that are defined in `XColorScheme`
You can define another base class that extends `XColorScheme`  and adds more colors to it.  
For example:
```dart
abstract class BaseColorScheme extends XColorScheme {
  ///Colors that needs to implemented for each theme.
  Color get containerBackgroundColor;

  ///Colors that needs to is used for each theme.
  static const Color blue = Colors.blue;
}
```

Then, We can make each theme color scheme class to extend  `BaseColorScheme`.  
Now we can have access to colors that defined in both  `XColorScheme`  and  `BaseColorScheme` in each theme color scheme.

Then, We can access each theme color scheme like this:
 ```dart  
  final colorScheme = AppTheme.colorScheme as BaseColorScheme;  
  final primary = colorScheme.primary;  
  ```

and use it in widget like this :
  ```dart
  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: colorScheme.primary);
  }
```



## See Also:
[playx_core](https://pub.dev/packages/playx_core) : core package of playx.

[Playx](https://pub.dev/packages/playx) : Playx eco system helps with redundant features , less code , more productivity , better organizing.