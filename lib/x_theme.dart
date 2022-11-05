import 'package:flutter/material.dart';

import 'package:playx_core/playx_core.dart';

/// wrapper around flutter `ThemeData`
class XTheme extends Equatable {
  // actual theme
  final ThemeData theme;
  // theme id
  final String id;
  // theme name builder

  final BuildA<String> nameBuilder;

  const XTheme({
    required this.theme,
    required this.id,
    required this.nameBuilder,
  });

  @override
  List<Object> get props => [
        id,
        theme,
        nameBuilder(),
      ];
}
