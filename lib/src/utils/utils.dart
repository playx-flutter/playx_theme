import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';

//Blends two color schemes together and returns a new color scheme.
ColorScheme getBlendedColorScheme(
  ColorScheme firstColorScheme,
  ColorScheme secondColorScheme,
) {
  final sourceColor = firstColorScheme.primary.toARGB32();
  final designColor = secondColorScheme.primary.toARGB32();
  final blended = Color(Blend.harmonize(designColor, sourceColor));

  return ColorScheme.fromSeed(
    seedColor: blended,
    brightness: firstColorScheme.brightness,
  );
}
