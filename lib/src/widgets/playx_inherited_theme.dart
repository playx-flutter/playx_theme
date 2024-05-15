import 'package:flutter/cupertino.dart';
import 'package:playx_theme/playx_theme.dart';

/// Inherited widget that provides the theme to the widget tree.
/// And notifies the widget tree when the theme changes.
class PlayxInheritedTheme extends InheritedWidget {
  final XTheme theme;
  const PlayxInheritedTheme(
      {super.key, required this.theme, required super.child});

  static PlayxInheritedTheme? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PlayxInheritedTheme>();

  static PlayxInheritedTheme of(BuildContext context) {
    final PlayxInheritedTheme? result =
        context.dependOnInheritedWidgetOfExactType<PlayxInheritedTheme>();
    assert(result != null, 'No PlayxInheritedTheme found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(PlayxInheritedTheme oldWidget) {
    return oldWidget.theme != theme;
  }
}
