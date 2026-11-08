import 'package:playx_core/playx_core.dart';

/// Abstraction over where PlayxTheme persists the last selected theme index
/// and theme mode.
///
/// Implement it to store the values anywhere (secure storage, Hive, a backend,
/// ...) and pass it through `PlayxThemeConfig.storage`.
abstract interface class PlayxThemeStorage {
  /// Reads the integer saved under [key], or `null` if there is none.
  Future<int?> getInt(String key);

  /// Saves [value] under [key].
  Future<void> setInt(String key, int value);

  /// Reads the string saved under [key], or `null` if there is none.
  Future<String?> getString(String key);

  /// Saves [value] under [key].
  Future<void> setString(String key, String value);

  /// Removes the value saved under [key].
  Future<void> remove(String key);
}

/// Default storage backed by `PlayxAsyncPrefs` (SharedPreferencesAsync).
class PlayxPrefsThemeStorage implements PlayxThemeStorage {
  const PlayxPrefsThemeStorage();

  @override
  Future<int?> getInt(String key) async {
    await PlayxAsyncPrefs.create();
    return PlayxAsyncPrefs.maybeGetInt(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await PlayxAsyncPrefs.create();
    return PlayxAsyncPrefs.setInt(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    await PlayxAsyncPrefs.create();
    return PlayxAsyncPrefs.maybeGetString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await PlayxAsyncPrefs.create();
    return PlayxAsyncPrefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await PlayxAsyncPrefs.create();
    return PlayxAsyncPrefs.remove(key);
  }
}

/// In-memory storage. Nothing survives an app restart; useful for tests.
class PlayxMemoryThemeStorage implements PlayxThemeStorage {
  final Map<String, Object> _values;

  PlayxMemoryThemeStorage([Map<String, Object>? initialValues])
    : _values = {...?initialValues};

  @override
  Future<int?> getInt(String key) async {
    final value = _values[key];
    return value is int ? value : null;
  }

  @override
  Future<void> setInt(String key, int value) async => _values[key] = value;

  @override
  Future<String?> getString(String key) async {
    final value = _values[key];
    return value is String ? value : null;
  }

  @override
  Future<void> setString(String key, String value) async =>
      _values[key] = value;

  @override
  Future<void> remove(String key) async => _values.remove(key);
}
