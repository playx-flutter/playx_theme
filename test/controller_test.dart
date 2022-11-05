import 'package:flutter_test/flutter_test.dart';
import 'package:playx_core/playx_core.dart';
import 'package:playx_theme/playx_theme.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(() async {
    await PlayXCore.bootCore();
    await AppTheme.boot();
  });
  tearDown(() async {
    await PlayXCore.dispose();
  });

  test(
    'updateByIndex does not throws if index is out of range',
    () async {
      await AppTheme.updateByIndex(333);
      expect(true, isTrue);
    },
  );
}
