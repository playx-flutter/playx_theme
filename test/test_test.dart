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
      await PlayxCore.bootCore();
      await PlayxPrefs.clear();
    },
  );
  tearDown(
    () async {
      await PlayxCore.dispose();
    },
  );
}
