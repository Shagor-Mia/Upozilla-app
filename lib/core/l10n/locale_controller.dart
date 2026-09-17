import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_repository.dart';

/// Supported app languages. Bangla is the hard default: a fresh install (or
/// a device locale we don't recognise) always opens in `bn`, regardless of
/// the system locale — the user must explicitly switch to `en`/`ar`.
class LocaleController extends Notifier<Locale> {
  @override
  Locale build() {
    final code = ref.read(localeRepositoryProvider).read();
    return code == null ? const Locale('bn') : Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    await ref.read(localeRepositoryProvider).write(locale.languageCode);
    state = locale;
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(LocaleController.new);
