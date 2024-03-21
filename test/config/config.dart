import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

final themeOutOFTheList = XTheme(
  id: '_id',
  name: '_name',
  themeData: ThemeData.dark(),
  colors: const XColors(),
);

final lightTestTheme = XTheme(
  id: 'Light',
  name: 'Light',
  themeData: ThemeData.light(),
  colors: const XColors(),
);

final darkTestTheme = XTheme(
  id: 'Dark',
  name: 'Dark',
  themeData: ThemeData.dark(),
  colors: const XColors(),
  isDark: true,
);

XThemeConfig getTestConfig({int initialThemeIndex = 0}) {
  return XThemeConfig(
    initialThemeIndex: initialThemeIndex,
    themes: [
      lightTestTheme,
      darkTestTheme,
    ],
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayxThemeBuilder(
      builder: (cxt, xTheme) => MaterialApp(
        theme: xTheme.themeData,
        home: Scaffold(
          body: Center(
            child: Text(PlayxTheme.index.toString()),
          ),
        ),
      ),
    );
  }
}
