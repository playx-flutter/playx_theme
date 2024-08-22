import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/src/widgets/playx_inherited_theme.dart';

import '../config/config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  group('PlayxInheritedTheme Test', () {
    testWidgets('PlayxInheritedTheme provides theme to descendants',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        PlayxInheritedTheme(
          theme: darkTestTheme,
          child: Builder(
            builder: (context) {
              final inheritedTheme = PlayxInheritedTheme.maybeOf(context);
              expect(inheritedTheme, isNotNull);
              expect(inheritedTheme!.theme.id, equals(darkTestTheme.id));
              return Container();
            },
          ),
        ),
      );
    });
  });
}
