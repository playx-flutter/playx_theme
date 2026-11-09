import 'package:flutter/material.dart';
import 'package:playx_core/playx_core.dart';

import '../storage/theme_storage.dart';

/// Reads and writes the selected theme index and mode through a
/// [PlayxThemeStorage].
///
/// All operations run one after another in call order, so when themes are
/// switched quickly the last requested theme is always the last one written.
class ThemePersistence {
  ThemePersistence(this.storage);

  static const indexKey = 'playx.theme.last_known_index';
  static const modeKey = 'playx.theme.last_known_theme_mode';

  final PlayxThemeStorage storage;

  Future<void> _queue = Future<void>.value();
  int _pending = 0;

  /// Runs [operation] after every previously queued one finished. A failure
  /// is reported to the caller but doesn't block the operations after it.
  ///
  /// When nothing is pending the operation starts right away, so no future is
  /// kept alive between calls (which also keeps it safe to use from
  /// different zones, e.g. `testWidgets`).
  Future<T> _enqueue<T>(Future<T> Function() operation) {
    final Future<T> result = _pending == 0
        ? Future<T>.sync(operation)
        : _queue.then((_) => operation());
    _pending++;
    _queue = result.then<void>((_) => _pending--, onError: (_) => _pending--);
    return result;
  }

  /// The last saved theme index.
  ///
  /// If [migrateLegacyPrefs] is true and nothing was saved yet, the index
  /// saved by older versions in `PlayxPrefs` is copied to the storage
  /// (using [fallbackIndex] if that has none either).
  Future<int?> loadIndex({
    bool migrateLegacyPrefs = false,
    int fallbackIndex = 0,
  }) => _enqueue(() async {
    final saved = await storage.getInt(indexKey);
    if (!migrateLegacyPrefs || saved != null) return saved;
    await PlayxPrefs.create();
    final legacy = PlayxPrefs.getInt(indexKey, fallback: fallbackIndex);
    await storage.setInt(indexKey, legacy);
    return legacy;
  });

  /// The last saved theme mode name.
  Future<String?> loadMode() => _enqueue(() => storage.getString(modeKey));

  Future<void> saveIndex(int index) =>
      _enqueue(() => storage.setInt(indexKey, index));

  Future<void> saveMode(ThemeMode mode) =>
      _enqueue(() => storage.setString(modeKey, mode.name));

  /// Removes the saved index and mode.
  Future<void> clear() => _enqueue(() async {
    await storage.remove(modeKey);
    await storage.remove(indexKey);
  });
}
