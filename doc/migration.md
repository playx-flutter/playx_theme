---
title: Migrating to 2.x
nav_order: 7
---

# Migrating

## 1.x to 2.0

- **SDK**: Dart `>=3.10` and Flutter `>=3.38` (raised to Dart `>=3.12` / Flutter `>=3.44` in 2.1).
- `initialThemeIndex` is now nullable. Use `initialThemeMode` to start from a mode.
- `PlayxThemeConfig` has `lightThemeIndex` and `darkThemeIndex`.
- Update methods take `updateMode` to control whether the `ThemeMode` follows the theme.
- A theme saved by 1.x (index only) is still restored.

## 2.0 to 2.1

No breaking API changes. New: `nextIndex`/`nextTheme`, `toggleMode`, `context.themeMode`,
`ThemeExtension` helpers, `PlayxThemeStorage`, `PlayxThemeAnimation.lerp`.

Behavior changes:

- Asking for a mode that has no theme throws without changing the saved mode.
- `PlayxThemeBuilder` no longer disposes the controller; call `PlayxTheme.dispose()` if needed.
