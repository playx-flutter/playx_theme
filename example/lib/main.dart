import 'package:example/config/config.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// * boot the core
  await PlayXCore.bootCore();

  /// boot the AppTheme
  await PlayxTheme.boot(config: const ThemeConfig());

  /// run the real app
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return PlayXThemeBuilder(
      builder: (xTheme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: xTheme.theme(locale),
          home: const MyHomePage(),
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

      body: Center(
        child: Text('Playx Theme', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 20),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: PlayxTheme.next,
        tooltip: 'Next Theme',
        child: Icon(
          Icons.add,
          color: context.colorScheme.onPrimary,
        ),
      ),

    );
  }
}

XColors get colorScheme => PlayxTheme.colors;
