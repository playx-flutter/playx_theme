import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(() async {
    PlayxPrefs.setMockInitialValues({});
    await PlayxCore.bootCore();
    await PlayxTheme.boot();
  });
  tearDown(() async {
    await PlayxCore.dispose();
  });

  test(
    'updateByIndex does not throws if index is out of range',
    () async {
      await PlayxTheme.updateByIndex(333);
      expect(true, isTrue);
    },
  );
}
