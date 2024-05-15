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
            theme: xTheme.themeBuilder?.call(const Locale('en')) ??
                xTheme.themeData,
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(),
            },
          );
        });
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayxThemeSwitchingArea(
      child: Scaffold(
        backgroundColor: PlayxColors.of(context).background,
        appBar: AppBar(
          title: const Text('Playx Theme'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text('Playx Theme Switcher'),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PlayxColors.of(context).primaryContainer,
                ),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    // false = user must tap button, true = tap outside dialog
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('title'),
                        content: Column(
                          children: List.generate(
                              PlayxTheme.supportedThemes.length,
                              (index) => Card(
                                    margin: const EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: BorderSide(
                                        color: PlayxTheme.id ==
                                                PlayxTheme
                                                    .supportedThemes[index].id
                                            ? PlayxColors.of(context).primary
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(32),
                                      title: Text(PlayxTheme
                                          .supportedThemes[index].name),
                                      trailing: PlayxTheme.id ==
                                              PlayxTheme
                                                  .supportedThemes[index].id
                                          ? const Icon(Icons.check)
                                          : null,
                                      onTap: () async {
                                        // PlayxTheme.updateByIndex(
                                        //   index,
                                        // );
                                        Navigator.of(dialogContext)
                                            .pop(); // Dismiss alert dialog

                                        PlayxTheme.updateById(PlayxTheme
                                            .supportedThemes[index].id);
                                      },
                                    ),
                                  )),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('buttonText'),
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Dismiss alert dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Theme'),
              ),
              PlayxThemeSwitcher(
                builder: (ctx, theme) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PlayxColors.of(context).primaryContainer,
                  ),
                  onPressed: () {
                    PlayxTheme.next(
                      context: ctx,
                    );
                  },
                  child: const Text('Next Theme'),
                ),
              ),
            ],
          ),
        ),
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
    );
  }
}

// XColors get colorScheme => PlayxTheme.colors;
