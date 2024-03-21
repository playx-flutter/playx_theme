import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/controller.dart';

import '../config/config.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(() async {
    PlayxPrefs.setMockInitialValues({XThemeController.lastKnownIndexKey: 1});
    await PlayxCore.bootCore();
    await PlayxTheme.boot(config: getTestConfig());
  });

  tearDown(
    () async {
      await PlayxCore.dispose();
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
            PlayxPrefs.getInt(XThemeController.lastKnownIndexKey, fallback: 0),
            0);
      },
    );
  });
}
