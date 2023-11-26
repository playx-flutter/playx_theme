import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';

import 'config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(() async {
    await PlayxCore.bootCore();
    PlayxPrefs.setMockInitialValues({XThemeController.lastKnownIndexKey: 2});
    await PlayxTheme.boot(config: TestConfig());
  });

  tearDown(
    () async {
      await PlayxCore.dispose();
    },
  );
  test(
    'it saves the theme to shared preferences',
    () async {
      await PlayxTheme.next();
      expect(PlayxPrefs.getInt(XThemeController.lastKnownIndexKey, fallback: 0), PlayxTheme.index);
    },
  );
  testWidgets(
    'it loads last selected theme when it boots',
    (WidgetTester tester) async {
      /// * pump the app
      await tester.pumpWidget(const TestApp());

      final counterZero = find.text(PlayxTheme.index.toString());
      expect(counterZero, findsOneWidget);
    },
  );
}
