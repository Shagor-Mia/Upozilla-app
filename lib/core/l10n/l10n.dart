import 'package:flutter/widgets.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// `context.l10n.someKey` — the generated class is produced by
/// `flutter gen-l10n` (runs automatically on `flutter pub get`/build).
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
