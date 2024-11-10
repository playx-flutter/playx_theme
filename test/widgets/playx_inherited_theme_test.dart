import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/widgets/playx_inherited_theme.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('PlayxInheritedTheme Tests', () {
    testWidgets('Access PlayxInheritedTheme using of() and maybeOf()',
        (WidgetTester tester) async {
      // Mock or create a sample theme
      final mockTheme = XTheme(
        id: 'theme1',
        name: 'Light Theme',
        colors: PlayxColors(
          primary: Colors.blue,
          secondary: Colors.green,
        ),
        themeData: ThemeData.light(),
      );

      // Build a widget tree with PlayxInheritedTheme
      await tester.pumpWidget(
        MaterialApp(
          home: PlayxInheritedTheme(
            theme: mockTheme,
            child: Builder(
              builder: (context) {
                // Test accessing the theme using of()
                final inheritedTheme = PlayxInheritedTheme.of(context);
                expect(inheritedTheme.theme.colors.primary.value,
                    Colors.blue.value);
                expect(inheritedTheme.theme.colors.secondary.value,
                    Colors.green.value);

                // Test accessing the theme using maybeOf()
                final inheritedThemeMaybe =
                    PlayxInheritedTheme.maybeOf(context);
                expect(inheritedThemeMaybe?.theme.colors.primary.value,
                    Colors.blue.value);
                expect(inheritedThemeMaybe?.theme.colors.secondary.value,
                    Colors.green.value);

                return Container();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('Throws error if PlayxInheritedTheme is not in the widget tree',
        (WidgetTester tester) async {
      // Build a widget tree without PlayxInheritedTheme
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Expect an error when calling PlayxInheritedTheme.of()
              expect(
                () => PlayxInheritedTheme.of(context),
                throwsFlutterError,
              );
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('Update theme and notify child widgets',
        (WidgetTester tester) async {
      // Create two themes for comparison
      final theme1 = XTheme(
        id: 'theme1',
        name: 'Light Theme',
        colors: PlayxColors(
          primary: Colors.blue,
          secondary: Colors.green,
        ),
        themeData: ThemeData.light(),
      );
      final theme2 = XTheme(
        id: 'theme2',
        name: 'Dark Theme',
        colors: PlayxColors(
          primary: Colors.red,
          secondary: Colors.yellow,
        ),
        themeData: ThemeData.dark(),
      );

      // Stateful widget to change the theme
      await tester.pumpWidget(
        MaterialApp(
          home: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 300)),
            builder: (context, s) {
              final theme =
                  s.connectionState == ConnectionState.done ? theme2 : theme1;
              return PlayxInheritedTheme(
                theme: theme,
                child: Builder(
                  builder: (context) {
                    // Access the theme before update
                    final inheritedTheme = PlayxInheritedTheme.of(context);
                    return Container(
                      color: inheritedTheme.theme.colors.primary,
                    );
                  },
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      final inheritedTheme =
          PlayxInheritedTheme.of(tester.element(find.byType(Container)));

      // Tap the IconButton to change the theme
      expect(inheritedTheme.theme.colors.primary.value, Colors.blue.value);
      expect(inheritedTheme.theme.colors.secondary.value, Colors.green.value);

      await tester.pump(Duration(milliseconds: 400));
      // Access the theme after update
      final inheritedTheme2 =
          PlayxInheritedTheme.of(tester.element(find.byType(Container)));
      expect(inheritedTheme2.theme.colors.primary.value, Colors.red.value);
      expect(inheritedTheme2.theme.colors.secondary.value, Colors.yellow.value);
    });
  });
}
