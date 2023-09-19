import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/model/colors/dark_colors.dart';
import 'package:playx_theme/src/model/colors/light_colors.dart';

final themeOutOFTheList = XTheme(
  id: '_id',
  name: '_name',
  theme: (locale) => ThemeData.dark(),
  colors: LightColorScheme(),
);

class TestConfig extends XThemeConfig {
  @override
  List<XTheme> get themes => [
        XTheme(
          theme:(locale)=> ThemeData.dark(),
          name: 'Dark',
          id: 'Dark',
          colors: DarkColorScheme(),
        ),
        XTheme(
          theme:(locale)=>ThemeData(
            scaffoldBackgroundColor: Colors.yellow,
          ),
          name: 'Yellow',
          id: 'Yellow',
          colors: DarkColorScheme(),
        ),
        XTheme(
          theme: (locale)=>ThemeData.light(),
          name: 'Light',
          id: 'Light',
          colors: LightColorScheme(),
        ),
        XTheme(
          theme:(locale)=> ThemeData(
            scaffoldBackgroundColor: Colors.red,
          ),
          name: 'Red',
          id: 'Red',
          colors: DarkColorScheme(),
        ),
        XTheme(
          theme:(locale)=> ThemeData(
            scaffoldBackgroundColor: Colors.cyan,
          ),
          name: 'cyan',
          id: 'cyan',
          colors: LightColorScheme(),
        ),
        themeOutOFTheList,
      ];
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return PlayXThemeBuilder(
      builder: (xTheme) => MaterialApp(
        theme: xTheme.theme(locale),
        home: Scaffold(
          body: Center(
            child: Text(PlayxTheme.index.toString()),
          ),
        ),
      ),
    );
  }
}
