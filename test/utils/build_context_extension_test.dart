import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/src/utils/build_context_extension.dart';
import 'package:playx_theme/src/widgets/playx_inherited_theme.dart';

import '../config/config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  group('PlayxTheme  BuildContext Extensions Test', () {
    testWidgets('XTheme can be accessed from BuildContext',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        PlayxInheritedTheme(
          theme: darkTestTheme,
          child: Builder(
            builder: (context) {
              final inheritedTheme = context.xTheme;
              expect(inheritedTheme, isNotNull);
              expect(inheritedTheme.id, equals(darkTestTheme.id));
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('PlayxColors can be accessed from BuildContext',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        PlayxInheritedTheme(
          theme: darkTestTheme,
          child: Builder(
            builder: (context) {
              final inheritedTheme = context.xTheme;
              expect(inheritedTheme, isNotNull);
              expect(inheritedTheme.id, equals(darkTestTheme.id));

              final colors = context.playxColors;
              expect(colors, isNotNull);
              expect(colors.primary, equals(darkTestTheme.colors.primary));
              expect(colors.secondary, equals(darkTestTheme.colors.secondary));
              expect(colors.surface, equals(darkTestTheme.colors.surface));
              expect(colors.onSurface, equals(darkTestTheme.colors.onSurface));

              return Container();
            },
          ),
        ),
      );
    });
  });
}
