import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Distinguishes "device is offline" from "server is failing" (Section 8.2).
class ConnectivityService {
  ConnectivityService([Connectivity? connectivity]) : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> isOffline() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _noneOnly(results);
    } catch (_) {
      // If the platform channel fails, assume online so we do not hide real errors.
      return false;
    }
  }

  Stream<bool> get onOfflineChanged => _connectivity.onConnectivityChanged.map(_noneOnly);

  static bool _noneOnly(List<ConnectivityResult> results) =>
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);
}

final connectivityServiceProvider = Provider<ConnectivityService>((ref) => ConnectivityService());

/// `true` while the device has no network; drives the [OfflineBanner].
final isOfflineProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onOfflineChanged;
});
