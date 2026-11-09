import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playx_theme/playx_theme.dart';
import 'package:playx_theme/src/controller/theme_persistence.dart';

/// Storage whose writes take longer the earlier they were requested, so
/// without serialization the first write would finish last.
class _SlowStorage extends PlayxMemoryThemeStorage {
  int _calls = 0;
  final writes = <int>[];

  @override
  Future<void> setInt(String key, int value) async {
    final delay = Duration(milliseconds: 30 - 10 * _calls++);
    await Future<void>.delayed(delay);
    writes.add(value);
    await super.setInt(key, value);
  }
}

class _FailingStorage extends PlayxMemoryThemeStorage {
  bool fail = true;

  @override
  Future<void> setInt(String key, int value) async {
    if (fail) throw StateError('disk full');
    return super.setInt(key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('writes are applied in call order', () async {
    final storage = _SlowStorage();
    final persistence = ThemePersistence(storage);

    await Future.wait([
      persistence.saveIndex(1),
      persistence.saveIndex(2),
      persistence.saveIndex(3),
    ]);

    expect(storage.writes, [1, 2, 3]);
    expect(await storage.getInt(ThemePersistence.indexKey), 3);
  });

  test('a failed write is reported but does not block later ones', () async {
    final storage = _FailingStorage();
    final persistence = ThemePersistence(storage);

    final failing = persistence.saveIndex(1);
    storage.fail = false;
    final ok = persistence.saveIndex(2);

    await expectLater(failing, throwsStateError);
    await ok;
    expect(await storage.getInt(ThemePersistence.indexKey), 2);
  });

  test('reads wait for pending writes', () async {
    final persistence = ThemePersistence(_SlowStorage());
    unawaited(persistence.saveIndex(7));
    expect(await persistence.loadIndex(), 7);
  });

  test('mode and clear', () async {
    final storage = PlayxMemoryThemeStorage();
    final persistence = ThemePersistence(storage);
    await persistence.saveMode(ThemeMode.dark);
    await persistence.saveIndex(1);
    expect(await persistence.loadMode(), 'dark');
    await persistence.clear();
    expect(await persistence.loadMode(), isNull);
    expect(await persistence.loadIndex(), isNull);
  });
}

final lightTheme = XTheme(id: 'l', name: 'l', themeData: ThemeData.light());
final lightTheme2 = XTheme(id: 'l2', name: 'l2', themeData: ThemeData.light());
final darkTheme = XTheme(
  id: 'd',
  name: 'd',
  themeData: ThemeData.dark(),
  isDark: true,
);
