import 'package:example/colors/base_colors.dart';
import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

class DarkColorScheme extends BaseColors {
  DarkColorScheme()
      : super(
            colorScheme: SeedColorScheme.fromSeeds(
          primaryKey: Colors.blue,
          brightness: Brightness.dark,
        ));

  @override
  Color get containerBackgroundColor => PlayxColors.darkGrey;
}
