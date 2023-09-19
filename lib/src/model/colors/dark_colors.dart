import 'dart:ui';

import 'package:playx_theme/src/model/colors/base_colors.dart';
import 'package:playx_theme/src/model/x_color_scheme.dart';

class DarkColorScheme extends BaseColors {
  @override
  Color get background => XColors.darkGrey;

  @override
  Color get error => XColors.redLight;

  @override
  Color get onBackground => XColors.white;

  @override
  Color get onError => XColors.black;

  @override
  Color get onPrimary => XColors.black;

  @override
  Color get onSecondary => XColors.black;

  @override
  Color get onSurface => XColors.white;

  @override
  Color get primary => XColors.blueLighterMain;

  @override
  Color get secondary => XColors.purpleLighterMain;

  @override
  Color get surface => XColors.darkGrey;

  @override
  Color get containerBackgroundColor => XColors.darkGrey;
}
