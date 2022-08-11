import 'package:flutter_test/flutter_test.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/controller.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(() async {
    await PlayXCore.bootCore();
    SharedPreferences.setMockInitialValues({
      XThemeController.lastKnownIndexKey: 2,
    });
    await AppTheme.boot(config: TestConfig());
  });

  tearDown(
    () async {
      await PlayXCore.disbose();
    },
  );
  test(
    'it saves the theme to shared preferences',
    () async {
      await AppTheme.next();
      expect(Prefs.getInt(XThemeController.lastKnownIndexKey), AppTheme.index);
    },
  );
  testWidgets(
    'it loads last selected theme when it boots',
    (WidgetTester tester) async {
      /// * pump the app
      await tester.pumpWidget(const TestApp());

      final counterZero = find.text(AppTheme.index.toString());
      expect(counterZero, findsOneWidget);
    },
  );
}
