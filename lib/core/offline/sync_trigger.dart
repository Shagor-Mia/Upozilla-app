import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/connectivity.dart';
import '../observability/logger.dart';
import 'sync_engine.dart';

/// Runs the first full offline sync as soon as the app starts, then resyncs
/// whenever connectivity is regained (offline -> online transition). Purely
/// fire-and-forget: [SyncEngine.syncAll] already isolates and logs per-entity
/// failures, so nothing here needs to surface errors to the UI.
///
/// Watched once from the app root ([UpazilaApp]) so it initializes exactly
/// once for the app's lifetime.
final offlineSyncStarterProvider = Provider<void>((ref) {
  final engine = ref.watch(syncEngineProvider);

  Future<void> runSync() async {
    AppLogger.info('offline sync starting', tag: 'offline_sync');
    await engine.syncAll();
    AppLogger.info('offline sync finished', tag: 'offline_sync');
  }

  unawaited(runSync());

  var wasOffline = false;
  final subscription = ref.listen<AsyncValue<bool>>(isOfflineProvider, (previous, next) {
    final isOffline = next.valueOrNull ?? false;
    if (wasOffline && !isOffline) {
      unawaited(runSync());
    }
    wasOffline = isOffline;
  });

  ref.onDispose(subscription.close);
});
