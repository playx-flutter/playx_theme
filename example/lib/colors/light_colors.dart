import 'package:example/colors/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

class LightColorScheme extends BaseColors {
  LightColorScheme()
      : super(
            colorScheme: SeedColorScheme.fromSeeds(
          primaryKey: Colors.blue,
          secondaryKey: Colors.blue,
          brightness: Brightness.light,
        ));
  // colorScheme: ColorScheme.fromSeed(
  //     seedColor: Colors.blue, brightness: Brightness.light));

  @override
  Color get containerBackgroundColor => PlayxColors.white;
}
