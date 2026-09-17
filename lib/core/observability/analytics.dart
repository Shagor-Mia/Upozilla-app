import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logger.dart';

/// Product analytics abstraction. Firebase Analytics / facebook_app_events
/// (Section 16.5) are deliberately not wired yet; swap [NoopAnalyticsService]
/// for a real implementation via [analyticsProvider] when a project exists.
abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?> params = const {}});

  Future<void> logScreenView(String screenName);

  Future<void> setUserId(String? userId);
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> logEvent(String name, {Map<String, Object?> params = const {}}) async {
    AppLogger.debug('event $name', tag: 'analytics', fields: params);
  }

  @override
  Future<void> logScreenView(String screenName) async {
    AppLogger.debug('screen $screenName', tag: 'analytics');
  }

  @override
  Future<void> setUserId(String? userId) async {}
}

final analyticsProvider = Provider<AnalyticsService>((ref) => const NoopAnalyticsService());
