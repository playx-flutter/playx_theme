import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// boot the AppTheme
  await AppTheme.boot();

  /// run the real app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayXThemeBuilder(
      builder: (xTheme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: xTheme.theme,
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayX Themes Demo Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: AppTheme.next,
        tooltip: 'Next Theme',
        child: Icon(
          Icons.add,
          color: colorScheme.onBackground,
        ),
      ),
    );
  }
}

XColorScheme get colorScheme => AppTheme.colorScheme;
