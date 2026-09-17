import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Hive-backed store for the user's chosen app language: a thin wrapper
/// around one Hive box, opened once in bootstrap before the ProviderScope
/// override.
class LocaleRepository {
  LocaleRepository(this._box);

  static const boxName = 'locale_prefs_v1';
  static const _languageCodeKey = 'language_code';

  final Box<String> _box;

  static Future<LocaleRepository> open() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>(boxName);
    return LocaleRepository(box);
  }

  /// The previously chosen language code (e.g. `bn`/`en`/`ar`), or `null` if
  /// the user has never picked one — callers should default to Bangla.
  String? read() => _box.get(_languageCodeKey);

  Future<void> write(String languageCode) => _box.put(_languageCodeKey, languageCode);
}

/// Overridden in bootstrap once the Hive box is open.
final localeRepositoryProvider = Provider<LocaleRepository>((ref) {
  throw UnimplementedError('localeRepositoryProvider must be overridden in bootstrap');
});
