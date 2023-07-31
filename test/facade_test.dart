import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';

import 'config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await PlayXCore.bootCore();
    await Prefs.clear();
    await PlayxTheme.boot(config: TestConfig());
  });
  tearDown(() async {
    await PlayXCore.dispose();
  });
  test('it updates theme', () async {
    expect(PlayxTheme.xTheme == themeOutOFTheList, isFalse);
    PlayxTheme.updateTo(themeOutOFTheList);
    expect(PlayxTheme.xTheme == themeOutOFTheList, isTrue);
  });

  test('it updates theme by index', () async {
    expect(
      PlayxTheme.xTheme.name == 'Red',
      isFalse,
    );
    await PlayxTheme.updateByIndex(3);
    expect(
      PlayxTheme.xTheme.name,
      'Red',
    );
  });
}
