import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Broadcasts "the refresh token is dead, force logout" from the Dio layer to
/// the auth feature without core/ depending on features/.
class SessionExpiryNotifier extends ChangeNotifier {
  void notifyExpired() => notifyListeners();
}

final sessionExpiryProvider = Provider<SessionExpiryNotifier>((ref) {
  final notifier = SessionExpiryNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
});
