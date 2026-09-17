import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppFlavor { dev, staging, prod }

/// Immutable per-flavor configuration, populated from `--dart-define` values
/// by the bootstrap entrypoints (Section 8.4: never hardcode a base URL).
class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    this.sentryDsn = '',
    this.mapboxToken = '',
  });

  final AppFlavor flavor;
  final String apiBaseUrl;
  final String sentryDsn;
  final String mapboxToken;

  bool get isProd => flavor == AppFlavor.prod;
  bool get sentryEnabled => sentryDsn.isNotEmpty;
  bool get mapboxEnabled => mapboxToken.isNotEmpty;

  /// Origin for the messaging WebSocket (Section 10), derived from the API
  /// base URL the same way `frontend/lib/config.ts` derives `wsBaseUrl`.
  String get wsBaseUrl => apiBaseUrl.replaceFirst('http', 'ws');

  /// Reads the compile-time defines. Every value has a sane dev default so a
  /// bare `flutter run` works against a local backend.
  static AppConfig fromEnvironment({required AppFlavor flavor}) {
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8000/api/v1',
    );
    const sentryDsn = String.fromEnvironment('SENTRY_DSN');
    const mapboxToken = String.fromEnvironment('MAPBOX_TOKEN');
    return AppConfig(
      flavor: flavor,
      apiBaseUrl: apiBaseUrl,
      sentryDsn: sentryDsn,
      mapboxToken: mapboxToken,
    );
  }

  static AppFlavor flavorFromString(String raw) {
    switch (raw.toLowerCase()) {
      case 'prod':
      case 'production':
        return AppFlavor.prod;
      case 'staging':
        return AppFlavor.staging;
      default:
        return AppFlavor.dev;
    }
  }
}

/// Overridden in [ProviderScope] by the bootstrap; throwing here makes a
/// missing override fail loudly instead of silently pointing at the wrong API.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden in bootstrap');
});
