import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/model/colors/dark_color_scheme.dart';
import 'package:playx_theme/src/model/colors/light_color_scheme.dart';

final themeOutOFTheList = XTheme(
  id: '_id',
  name: '_name',
  theme: ThemeData.dark(),
  colorScheme: LightColorScheme(),
);

class TestConfig extends XThemeConfig {
  @override
  List<XTheme> get themes => [
        XTheme(
          theme: ThemeData.dark(),
          name: 'Dark',
          id: 'Dark',
          colorScheme: DarkColorScheme(),
        ),
        XTheme(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.yellow,
          ),
          name: 'Yellow',
          id: 'Yellow',
          colorScheme: DarkColorScheme(),
        ),
        XTheme(
          theme: ThemeData.light(),
          name: 'Light',
          id: 'Light',
          colorScheme: LightColorScheme(),
        ),
        XTheme(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.red,
          ),
          name: 'Red',
          id: 'Red',
          colorScheme: DarkColorScheme(),
        ),
        XTheme(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.cyan,
          ),
          name: 'cyan',
          id: 'cyan',
          colorScheme: LightColorScheme(),
        ),
        themeOutOFTheList,
      ];
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayXThemeBuilder(
      builder: (xTheme) => MaterialApp(
        theme: xTheme.theme,
        home: Scaffold(
          body: Center(
            child: Text(AppTheme.index.toString()),
          ),
        ),
      ),
    );
  }
}
