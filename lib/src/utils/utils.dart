import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

//Blends two color schemes together and returns a new color scheme.
ColorScheme getBlendedColorScheme(
  ColorScheme firstColorScheme,
  ColorScheme secondColorScheme,
) {
  final sourceColor = getColorValue(firstColorScheme.primary);
  final designColor = getColorValue(secondColorScheme.primary);
  final blended = Color(Blend.harmonize(designColor, sourceColor));

  return ColorScheme.fromSeed(
    seedColor: blended,
    brightness: firstColorScheme.brightness,
  );
}

int _floatToInt8(double x) {
  return (x * 255.0).round() & 0xff;
}

int getColorValue(Color color) {
  final a = color.a;
  final r = color.r;
  final g = color.g;
  final b = color.b;
  return _floatToInt8(a) << 24 |
      _floatToInt8(r) << 16 |
      _floatToInt8(g) << 8 |
      _floatToInt8(b) << 0;
}
