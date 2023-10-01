import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// This is base class for creating custom colors for each theme.
/// You can create this class of you want to add more colors that will be implemented in each theme colors
/// or if you want to add const colors for each theme.
/// If you don't need this functionality you can make each theme color scheme extends `XColorScheme` class
/// You can define a function to get the color scheme like this:
/// ```dart
///  BaseColorScheme get colorScheme => PlayxTheme.colors as BaseColors;
///  final primary = colorScheme.primary;
///  ```
///  Now you can access each theme color.
abstract class BaseColors extends XColors {
  ///Colors that needs to implemented for each theme.
  Color get containerBackgroundColor;

  final ColorScheme colorScheme;

  BaseColors({required this.colorScheme}) : super.fromColorScheme(scheme: colorScheme);


  ///Colors that needs to is used for each theme.
  static const Color blue = Colors.blue;
}
