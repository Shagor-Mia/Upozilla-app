// Fails CI if a translation key exists in one of app_en.arb/app_bn.arb/app_ar.arb but not
// the others - the ARB files are hand-maintained (Section 5 i18n) with no tooling otherwise
// enforcing key parity, so a feature PR can silently ship with a missing bn/ar string.
//
// Usage: dart run tool/check_l10n_parity.dart

import 'dart:convert';
import 'dart:io';

const _arbDir = 'lib/core/l10n';
const _locales = ['en', 'bn', 'ar'];

Set<String> _keysOf(Map<String, dynamic> arb) {
  return arb.keys.where((k) => !k.startsWith('@') && k != '@@locale').toSet();
}

void main() {
  final keysByLocale = <String, Set<String>>{};
  for (final locale in _locales) {
    final file = File('$_arbDir/app_$locale.arb');
    final arb = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    keysByLocale[locale] = _keysOf(arb);
  }

  final allKeys = keysByLocale.values.expand((keys) => keys).toSet();
  var ok = true;

  for (final locale in _locales) {
    final missing = allKeys.difference(keysByLocale[locale]!);
    if (missing.isNotEmpty) {
      ok = false;
      final sorted = missing.toList()..sort();
      stderr.writeln('app_$locale.arb is missing ${missing.length} key(s): ${sorted.join(', ')}');
    }
  }

  if (!ok) {
    stderr.writeln('\nl10n key parity check failed - add the missing keys above to every locale.');
    exit(1);
  }

  stdout.writeln('l10n key parity OK (${allKeys.length} keys across ${_locales.join('/')}).');
}
