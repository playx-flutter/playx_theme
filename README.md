# Playx Theme

# Get Started

# Features 🔥

- no need for `BuildContext` (you still can access the theme from the context if you need 😉)
- works out of the box
  - no need to store or load the last used theme by your self

### boot the core

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
