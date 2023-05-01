# Playx Theme
Multi theme features for flutter apps from playx eco system.

# Features 🔥
- Create and mange app theme with the ability to easily change app theme.
- no need for `BuildContext` (you still can access the theme from the context if you need 😉)
- works out of the box
- no need to store or load the last used theme by your self

## Playx:
Consider using our [Playx Package](https://pub.dev/packages/playx):
Which comes prepakaged with Playx Theme with more features and is easy to use.

## Installation

in `pubspec.yaml` add these lines to `dependencies`

```yaml  
playx_theme: ^0.0.3 
```  

## Usage
### Boot the core

```dart
 void main ()async{
 WidgetsFlutterBinding.ensureInitialized();

  /// boot the core
  await PlayXCore.bootCore();

  /// boot the theme
  /// you can provide `XThemeConfig` to add your custom themes
  await AppTheme.boot();

  /// run the real app
  runApp(const MyApp());
}
```

### Wrap Your App With `PlayXThemeBuilder`

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

### Thats it

use `AppTheme` facade to switch between themes
With `AppTheme` you will have access to current app theme, it's index, name and id.

```dart 
    FloatingActionButton(
        //Change App theme to the next theme in Theme Config.
        onPressed: AppTheme.next,
        child: Icon(Icons.next),
      ),
```
## See Also:
[playx_core](https://pub.dev/packages/playx_core) : core pakage of playx.

[Playx](https://pub.dev/packages/playx) : Playx eco system helps with redundant features , less code , more productivity , better organizing.