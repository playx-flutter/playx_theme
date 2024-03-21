import 'package:flutter/material.dart';
import 'package:playx_theme/playx_theme.dart';

/// Widget that is themed by image content by providing image provider.
/// As it generates color scheme from image content.
class ImageTheme extends StatelessWidget {
  const ImageTheme(
      {super.key,
      required this.provider,
      required this.child,
      this.shouldBlendWithCurrentScheme = false});

  final ImageProvider provider;
  final bool shouldBlendWithCurrentScheme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: _getColorScheme(context),
      builder: (context, snapshot) {
        final scheme = snapshot.data ?? theme.colorScheme;
        return Theme(
          data: theme.copyWith(colorScheme: scheme),
          child: child,
        );
      },
    );
  }

  Future<ColorScheme> _getColorScheme(BuildContext context) async {
    final currentColorScheme = context.colorScheme;
    final imageColorScheme =
        await ColorScheme.fromImageProvider(provider: provider);
    if (shouldBlendWithCurrentScheme) {
      return getBlendedColorScheme(currentColorScheme, imageColorScheme);
    }
    return imageColorScheme;
  }
}
