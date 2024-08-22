import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../config/config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(() async {
    PlayxPrefs.setMockInitialValues({XThemeController.lastKnownIndexKey: 1});
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(
            {XThemeController.lastKnownIndexKey: 1});
    await PlayxTheme.boot(config: getTestConfig());
  });

  tearDown(
    () async {
      await PlayxTheme.dispose();
    },
  );

  group('PlayxTheme test Prefs', () {
    test(
      'PlayxTheme loads last selected theme when it boots',
      () async {
        expect(PlayxTheme.index, 1);
      },
    );

    test(
      'PlayxTheme saves last selected theme index',
      () async {
        await PlayxTheme.updateById(lightTestTheme.id);
        expect(
            await PlayxAsyncPrefs.getInt(XThemeController.lastKnownIndexKey,
                fallback: 0),
            0);
      },
    );
  });
}
