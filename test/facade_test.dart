import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';

import 'config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await PlayXCore.bootCore();
    await Prefs.clear();
    await AppTheme.boot(config: TestConfig());
  });
  tearDown(() async {
    await PlayXCore.dispose();
  });
  test('it updates theme', () async {
    expect(AppTheme.xTheme == themeOutOFTheList, isFalse);
    AppTheme.updateTo(themeOutOFTheList);
    expect(AppTheme.xTheme == themeOutOFTheList, isTrue);
  });

  test('it updates theme by index', () async {
    expect(
      AppTheme.xTheme.name == 'Red',
      isFalse,
    );
    await AppTheme.updateByIndex(3);
    expect(
      AppTheme.xTheme.name,
      'Red',
    );
  });
}
