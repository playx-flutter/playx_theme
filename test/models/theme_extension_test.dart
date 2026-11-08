import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/widgets/playx_inherited_theme.dart';

class _Spacing extends ThemeExtension<_Spacing> {
  final double gap;
  const _Spacing(this.gap);

  @override
  _Spacing copyWith({double? gap}) => _Spacing(gap ?? this.gap);

  @override
  _Spacing lerp(covariant _Spacing? other, double t) =>
      _Spacing(gap + ((other?.gap ?? gap) - gap) * t);
}

void main() {
  final withExtension = XTheme(
    id: 'ext',
    name: 'Ext',
    themeData: ThemeData(extensions: const [_Spacing(8)]),
  );
  final withoutExtension = XTheme(
    id: 'plain',
    name: 'Plain',
    themeData: ThemeData(),
  );

  test('XTheme.extension returns the registered extension or null', () {
    expect(withExtension.extension<_Spacing>()?.gap, 8);
    expect(withoutExtension.extension<_Spacing>(), isNull);
  });

  testWidgets('context.themeExtension / maybeThemeExtension', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      PlayxInheritedTheme(
        theme: withExtension,
        child: Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(ctx.themeExtension<_Spacing>().gap, 8);
    expect(ctx.maybeThemeExtension<_Spacing>(), isNotNull);

    await tester.pumpWidget(
      PlayxInheritedTheme(
        theme: withoutExtension,
        child: Builder(
          builder: (c) {
            ctx = c;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(ctx.maybeThemeExtension<_Spacing>(), isNull);
    expect(() => ctx.themeExtension<_Spacing>(), throwsFlutterError);
  });
}
