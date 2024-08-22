import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/src/utils/utils.dart';

void main() {
  group('Utils', () {
    test('getBlendedColorScheme blends two color schemes correctly', () {
      const firstScheme = ColorScheme.light(primary: Colors.blue);
      const secondScheme = ColorScheme.dark(primary: Colors.red);

      final blendedScheme = getBlendedColorScheme(firstScheme, secondScheme);

      expect(blendedScheme.brightness, equals(firstScheme.brightness));
      expect(blendedScheme.primary, isNot(equals(firstScheme.primary)));
      expect(blendedScheme.primary, isNot(equals(secondScheme.primary)));
    });
  });
}
