import 'dart:ui';

import 'package:playx_theme/src/model/colors/base_color_scheme.dart';
import 'package:playx_theme/src/model/x_color_scheme.dart';

class DarkColorScheme extends BaseColorScheme {
  @override
  Color get background => XColorScheme.darkGrey;

  @override
  Color get error => XColorScheme.redLight;

  @override
  Color get onBackground => XColorScheme.white;

  @override
  Color get onError => XColorScheme.black;

  @override
  Color get onPrimary => XColorScheme.black;

  @override
  Color get onSecondary => XColorScheme.black;

  @override
  Color get onSurface => XColorScheme.white;

  @override
  Color get primary => XColorScheme.blueLighterMain;

  @override
  Color get secondary => XColorScheme.purpleLighterMain;

  @override
  Color get surface => XColorScheme.darkGrey;

  @override
  Color get containerBackgroundColor => XColorScheme.darkGrey;
}
