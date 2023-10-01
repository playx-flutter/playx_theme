import 'dart:ui';

import 'package:example/colors/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

class DarkColorScheme extends BaseColors {

  DarkColorScheme()
      : super(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark));

  @override
  Color get containerBackgroundColor => XColors.darkGrey;
}
