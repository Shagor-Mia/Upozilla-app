import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../app/app.dart';
import '../core/config/app_config.dart';
import '../core/l10n/locale_repository.dart';
import '../core/observability/logger.dart';
import '../core/offline/database.dart';

/// Flavor-aware startup shared by every `main_*.dart` entrypoint.
Future<void> bootstrap({required AppFlavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment(flavor: flavor);
  final offlineDatabase = OfflineDatabase();
  final localeRepository = await LocaleRepository.open();
  AppLogger.info('starting', tag: 'bootstrap', fields: {'flavor': flavor.name, 'api': config.apiBaseUrl});

  final app = ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(config),
      offlineDatabaseProvider.overrideWithValue(offlineDatabase),
      localeRepositoryProvider.overrideWithValue(localeRepository),
    ],
    child: const UpazilaApp(),
  );

  if (!config.sentryEnabled) {
    runApp(app);
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = config.sentryDsn;
      options.environment = flavor.name;
      options.tracesSampleRate = config.isProd ? 0.1 : 1.0;
      // Never ship PII (phones/emails) with crash reports (Section 14.4).
      options.sendDefaultPii = false;
    },
    appRunner: () => runApp(app),
  );
}
