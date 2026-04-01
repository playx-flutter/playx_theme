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
              const Text('Playx Theme Mode'),
              const SizedBox(height: 8),
              ValueListenableBuilder<ThemeMode>(
                valueListenable: PlayxTheme.themeModeNotifier,
                builder: (context, mode, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildThemeModeCard(
                        context,
                        title: 'Light',
                        icon: Icons.light_mode,
                        isSelected: mode == ThemeMode.light,
                        onTap: () => PlayxTheme.updateToLightMode(),
                      ),
                      _buildThemeModeCard(
                        context,
                        title: 'Dark',
                        icon: Icons.dark_mode,
                        isSelected: mode == ThemeMode.dark,
                        onTap: () => PlayxTheme.updateToDarkMode(),
                      ),
                      _buildThemeModeCard(
                        context,
                        title: 'System',
                        icon: Icons.settings_system_daydream,
                        isSelected: mode == ThemeMode.system,
                        onTap: () => PlayxTheme.updateToDeviceMode(),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text('Playx Theme Switcher'),
              const SizedBox(height: 8),
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
                                                  animate: true,
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
                    animation: PlayxThemeClipperAnimation(
                      duration: Duration(milliseconds: 500),
                    ),
                    animate: false,
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
                animate: false,
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

  Widget _buildThemeModeCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected
            ? context.playxColors.primary
            : context.playxColors.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isSelected
              ? BorderSide(color: context.playxColors.onPrimary, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            children: [
              Icon(icon,
                  color: isSelected
                      ? context.playxColors.onPrimary
                      : context.playxColors.onSurface),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? context.playxColors.onPrimary
                      : context.playxColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
