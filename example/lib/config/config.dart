import 'package:example/colors/dark_colors.dart';
import 'package:example/colors/light_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// used to configure out app theme by providing the app with the needed themes.
class ThemeConfig extends XThemeConfig {
  static LightColorScheme lightColors = LightColorScheme();
  static DarkColorScheme darkColors = DarkColorScheme();

  final config = XThemeConfig(
    themes: [
      XTheme(
          id: 'light',
          name: 'Light',
          themeData: ThemeData(
            brightness: Brightness.light,
            colorScheme: lightColors.colorScheme,
            useMaterial3: true,
          ),
          cupertinoThemeData: const CupertinoThemeData(
            brightness: Brightness.light,
          ),
          colors: lightColors),
      XTheme.builder(
          id: 'dark',
          name: 'Dark',
          initialTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: darkColors.colorScheme,
            useMaterial3: true,
          ),

          /// We can use builder to specify different theme data for each locale.
          themeBuilder: (locale) => ThemeData(
                brightness: Brightness.dark,
                colorScheme: darkColors.colorScheme,
                useMaterial3: true,
              ),
          cupertinoThemeBuilder: (locale) => const CupertinoThemeData(
                brightness: Brightness.dark,
              ),
          isDark: true,
          colors: darkColors),
    ],
    initialThemeIndex: PlayxTheme.isDeviceInDarkMode() ? 1 : 0,
  );

  ThemeConfig()
      : super(
          themes: [
            XTheme(
                id: 'light',
                name: 'Light',
                themeData: ThemeData(
                  brightness: Brightness.light,
                  colorScheme: lightColors.colorScheme,
                  useMaterial3: true,
                ),
                cupertinoThemeData: const CupertinoThemeData(
                  brightness: Brightness.light,
                ),
                colors: lightColors),
            XTheme.builder(
                id: 'dark',
                name: 'Dark',
                initialTheme: ThemeData(
                  brightness: Brightness.dark,
                  colorScheme: darkColors.colorScheme,
                  useMaterial3: true,
                ),

                /// We can use builder to specify different theme data for each locale.
                themeBuilder: (locale) => ThemeData(
                      brightness: Brightness.dark,
                      colorScheme: darkColors.colorScheme,
                      useMaterial3: true,
                    ),
                cupertinoThemeBuilder: (locale) => const CupertinoThemeData(
                      brightness: Brightness.dark,
                    ),
                isDark: true,
                colors: darkColors),
          ],
          initialThemeIndex: PlayxTheme.isDeviceInDarkMode() ? 1 : 0,
          saveTheme: true,
        );
}
