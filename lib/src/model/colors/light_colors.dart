import 'dart:ui';

import 'package:playx_theme/src/model/colors/base_colors.dart';
import 'package:playx_theme/src/model/x_color_scheme.dart';

class LightColorScheme extends BaseColors {
  @override
  Color get containerBackgroundColor => XColors.white;

  @override
  Color get background => XColors.white;

  @override
  Color get error => XColors.red;

  @override
  Color get onBackground => XColors.black;

  @override
  Color get onError => XColors.white;

  @override
  Color get onPrimary => XColors.white;

  @override
  Color get onSecondary => XColors.white;

  @override
  Color get onSurface => XColors.black;

  @override
  Color get primary => XColors.blueMain;

  @override
  Color get secondary => XColors.purpleMain;

  @override
  Color get surface => XColors.white;

}
