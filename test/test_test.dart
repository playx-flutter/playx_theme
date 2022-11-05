import 'package:flutter_test/flutter_test.dart';
import 'package:playx_core/playx_core.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
    },
  );

  setUp(
    () async {
      await PlayXCore.bootCore();
      await Prefs.clear();
    },
  );
  tearDown(
    () async {
      await PlayXCore.dispose();
    },
  );
}
