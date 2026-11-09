---
title: Persistence
nav_order: 5
---

# Persistence

The selected theme index and mode are saved when `saveTheme` is `true` (the default) and
restored on the next `boot`.

```dart
PlayxThemeConfig(
  themes: [...],
  saveTheme: false, // don't persist
)
```

Saved state wins over `initialThemeIndex` / `initialThemeMode`. Writes are applied in the
order the switches were requested, so the last requested theme is the one that is saved.

## Custom storage

Implement `PlayxThemeStorage` to keep the values anywhere:

```dart
class SecureThemeStorage implements PlayxThemeStorage {
  @override
  Future<int?> getInt(String key) async => /* ... */;
  @override
  Future<void> setInt(String key, int value) async {/* ... */}
  @override
  Future<String?> getString(String key) async => /* ... */;
  @override
  Future<void> setString(String key, String value) async {/* ... */}
  @override
  Future<void> remove(String key) async {/* ... */}
}

PlayxThemeConfig(themes: [...], storage: SecureThemeStorage());
```

The default is `PlayxPrefsThemeStorage` (`SharedPreferencesAsync`).
`PlayxMemoryThemeStorage` keeps values in memory, handy in tests.

## Clearing

```dart
await PlayxTheme.clearLastSavedTheme();
```
