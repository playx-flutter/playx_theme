import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../config/config.dart';

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
  testWidgets('PlayxThemeSwitcher triggers theme change with builder',
      (WidgetTester tester) async {
    Offset? switcherOffset;
    await tester.pumpWidget(
      TestApp(
        child: PlayxThemeSwitcher(
          builder: (context, theme) {
            return FloatingActionButton(
              onPressed: () {
                final animation = PlayxThemeAnimation.clipper(
                  context: context,
                );
                switcherOffset =
                    (animation as PlayxThemeClipperAnimation).switcherOffset;
                PlayxTheme.next(
                  animation: animation,
                ); // Trigger theme change
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(switcherOffset, isNotNull);
    expect(PlayxTheme.index, 1);
  });
}
