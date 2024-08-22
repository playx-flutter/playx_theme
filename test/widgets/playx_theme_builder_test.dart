import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../config/config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(
    () async {
      PlayxPrefs.setMockInitialValues({});
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
      await PlayxTheme.boot(config: getTestConfig());
    },
  );
  tearDown(
    () async {
      await PlayxTheme.clearLastSavedTheme();
      await PlayxTheme.dispose();
    },
  );

  group('PlayxThemeBuilder Test', () {
    testWidgets(
      'PlayxThemeBuilder should build the child widget with the current theme',
      (tester) async {
        await PlayxTheme.updateById(darkTestTheme.id);
        await tester.pumpWidget(const TestApp());
        expect(find.text('1'), findsOneWidget);
      },
    );
  });
}
