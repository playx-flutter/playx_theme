import 'package:example/config/config.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// * boot the core
  await PlayxCore.bootCore();

  /// boot the AppTheme
  await PlayxTheme.boot(config: ThemeConfig());

  /// run the app
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayxThemeBuilder(
      duration: const Duration(milliseconds: 300),
      builder: (ctx, xTheme) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: xTheme.themeData,
          home: PlayxThemeSwitchingArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Playx Theme'),
              ),
              body: const HomeScreen(),
              floatingActionButton: PlayxThemeSwitcher(
                builder: (ctx, theme) => FloatingActionButton(
                  onPressed: () {
                    PlayxTheme.next(
                        context: ctx, clipper: const ThemeSwitcherBoxClipper());
                  },
                  tooltip: 'Next Theme',
                  child: Icon(
                    Icons.add,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          PlayxTheme.supportedThemes.length,
          (index) => Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                    color: PlayxTheme.id == PlayxTheme.supportedThemes[index].id
                        ? colorScheme.primary
                        : Colors.transparent,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(32),
                  title: Text(PlayxTheme.supportedThemes[index].name),
                  trailing:
                      PlayxTheme.id == PlayxTheme.supportedThemes[index].id
                          ? const Icon(Icons.check)
                          : null,
                  onTap: () {
                    PlayxTheme.updateByIndex(
                      index,
                    );
                  },
                ),
              )),
    );
  }
}

XColors get colorScheme => PlayxTheme.colors;
