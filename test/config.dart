import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

final themeOutOFTheList = XTheme(
  id: '_id',
  nameBuilder: () => '_name',
  theme: ThemeData.dark(),
);

class TestConfig extends XThemeConfig {
  @override
  List<XTheme> get themes => [
        XTheme(
          theme: ThemeData.dark(),
          nameBuilder: () => 'Dark',
          id: 'Dark',
        ),
        XTheme(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.yellow,
          ),
          nameBuilder: () => 'Yellow',
          id: 'Yellow',
        ),
        XTheme(
          theme: ThemeData.light(),
          nameBuilder: () => 'Light',
          id: 'Light',
        ),
        XTheme(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.red,
          ),
          nameBuilder: () => 'Red',
          id: 'Red',
        ),
        XTheme(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.cyan,
          ),
          nameBuilder: () => 'cyan',
          id: 'cyan',
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
