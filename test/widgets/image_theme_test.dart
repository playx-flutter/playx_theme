import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';

// 1x1 red PNG.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8DwHwAFBQIAX8jx0gAAAABJRU5ErkJggg==',
);

void main() {
  for (final blend in [false, true]) {
    testWidgets('ImageTheme builds and keeps a valid scheme (blend: $blend)', (
      tester,
    ) async {
      ColorScheme? scheme;
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorSchemeSeed: Colors.blue),
          home: ImageTheme(
            provider: MemoryImage(_png),
            shouldBlendWithCurrentScheme: blend,
            child: Builder(
              builder: (context) {
                scheme = Theme.of(context).colorScheme;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      final initial = scheme;
      expect(initial, isNotNull);

      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 500)),
      );
      await tester.pump();
      expect(scheme, isNotNull);
    });
  }
}
