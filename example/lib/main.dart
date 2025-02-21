import 'package:example/config/config.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// boot the AppTheme
  await PlayxTheme.boot(config: ThemeConfig());

  /// run the app
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayxThemeBuilder(builder: (ctx, xTheme) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme:
            xTheme.themeBuilder?.call(const Locale('en')) ?? xTheme.themeData,
        home: const HomeScreen(),
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
        backgroundColor: PlayxColors.of(context).surface,
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
              SizedBox(
                width: 200,
                child: Card(
                  color: context.playxColors.surfaceContainerHigh,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            PlayxColors.of(context).primaryContainer,
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
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    PlayxTheme.supportedThemes.length,
                                    (index) => Card(
                                          margin: const EdgeInsets.all(8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: BorderSide(
                                              color: PlayxTheme.id ==
                                                      PlayxTheme
                                                          .supportedThemes[
                                                              index]
                                                          .id
                                                  ? context.playxColors.primary
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(32),
                                            title: Text(PlayxTheme
                                                .supportedThemes[index].name),
                                            trailing: PlayxTheme.id ==
                                                    PlayxTheme
                                                        .supportedThemes[index]
                                                        .id
                                                ? const Icon(Icons.check)
                                                : null,
                                            onTap: () async {
                                              // PlayxTheme.updateByIndex(
                                              //   index,
                                              // );
                                              Navigator.of(dialogContext)
                                                  .pop(); // Dismiss alert dialog

                                              PlayxTheme.updateById(
                                                  PlayxTheme
                                                      .supportedThemes[index]
                                                      .id,
                                                  animation:
                                                      const PlayxThemeAnimation
                                                          .horizontalSlide());
                                            },
                                          ),
                                        )),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Confirm'),
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
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PlayxColors.of(context).primaryContainer,
                ),
                onPressed: () {
                  PlayxTheme.next(
                    animation: const PlayxThemeFadeAnimation(
                      duration: Duration(milliseconds: 500),
                    ),
                  );
                },
                child: const Text('Next Theme'),
              ),
            ],
          ),
        ),
        floatingActionButton: PlayxThemeSwitcher(
          builder: (ctx, theme) => FloatingActionButton(
            onPressed: () {
              PlayxTheme.next(
                animation: PlayxThemeAnimation.clipper(
                    clipper: const ThemeSwitcherCircleClipper(), context: ctx),
              );
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
