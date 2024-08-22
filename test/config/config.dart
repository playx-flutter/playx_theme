import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

final themeOutOFTheList = XTheme(
  id: '_id',
  name: '_name',
  themeData: ThemeData.dark(),
  colors: const PlayxColors(),
);

final lightTestTheme = XTheme(
  id: 'Light',
  name: 'Light',
  themeData: ThemeData.light(),
  colors: const PlayxColors(),
);

final darkTestTheme = XTheme(
  id: 'Dark',
  name: 'Dark',
  themeData: ThemeData.dark(),
  colors: const PlayxColors(),
  isDark: true,
);

PlayxThemeConfig getTestConfig({int initialThemeIndex = 0}) {
  return PlayxThemeConfig(
    initialThemeIndex: initialThemeIndex,
    themes: [
      lightTestTheme,
      darkTestTheme,
    ],
  );
}

class TestApp extends StatelessWidget {
  final Widget? child;
  const TestApp({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PlayxThemeBuilder(
      builder: (cxt, xTheme) => MaterialApp(
        theme: xTheme.themeData,
        home: Scaffold(
          body: child ??
              Center(
                child: Text(PlayxTheme.index.toString()),
              ),
        ),
      ),
    );
  }
}
