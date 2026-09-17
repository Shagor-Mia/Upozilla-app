import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/session_expiry.dart';
import '../error/app_exception.dart';
import '../observability/analytics.dart';
import '../observability/logger.dart';
import 'auth_repository.dart';
import 'auth_state.dart';
import 'otp.dart';

/// Single source of truth for "who is signed in". Lives in core/ because the
/// router, profile and auth features all depend on it (Section 8.8: features
/// share state only through core/).
class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final expiry = ref.watch(sessionExpiryProvider);
    expiry.addListener(_onSessionExpired);
    ref.onDispose(() => expiry.removeListener(_onSessionExpired));
    return _restoreSession();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<AuthState> _restoreSession() async {
    if (!await _repository.hasSession()) return const AuthState.anonymous();
    try {
      final user = await _repository.me();
      await ref.read(analyticsProvider).setUserId(user.id);
      return AuthState.authenticated(user);
    } on UnauthorizedException {
      await _repository.clearSession();
      return const AuthState.anonymous();
    } on AppException catch (e) {
      // Keep the stored session; the profile loads on the next successful call.
      AppLogger.warn('could not load profile at launch', tag: 'auth', fields: {'reason': e.runtimeType});
      return const AuthState.authenticated(null);
    }
  }

  void _onSessionExpired() {
    AppLogger.info('session expired', tag: 'auth');
    state = const AsyncData(AuthState.anonymous());
  }

  Future<OtpRequestResult> requestOtp({required String phone, required OtpPurpose purpose}) {
    return _repository.requestOtp(phone: phone, purpose: purpose);
  }

  Future<void> verifyOtp({
    required String phone,
    required String code,
    required OtpPurpose purpose,
    String? fullName,
  }) async {
    await _repository.verifyOtp(phone: phone, code: code, purpose: purpose, fullName: fullName);
    await _loadProfile();
    await ref.read(analyticsProvider).logEvent('login', params: {'method': 'otp_${purpose.apiValue}'});
  }

  Future<void> loginWithPassword({required String identifier, required String password}) async {
    await _repository.loginWithPassword(identifier: identifier, password: password);
    await _loadProfile();
    await ref.read(analyticsProvider).logEvent('login', params: {'method': 'password'});
  }

  Future<void> refreshProfile() async {
    if (!(state.valueOrNull?.isAuthenticated ?? false)) return;
    await _loadProfile();
  }

  Future<void> signOut() async {
    await _repository.logout();
    await ref.read(analyticsProvider).setUserId(null);
    state = const AsyncData(AuthState.anonymous());
  }

  Future<void> _loadProfile() async {
    try {
      final user = await _repository.me();
      await ref.read(analyticsProvider).setUserId(user.id);
      state = AsyncData(AuthState.authenticated(user));
    } on UnauthorizedException {
      await _repository.clearSession();
      state = const AsyncData(AuthState.anonymous());
      rethrow;
    } on AppException {
      state = const AsyncData(AuthState.authenticated(null));
    }
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(AuthController.new);

/// Convenience: `true` only when a session exists (user may still be loading).
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isAuthenticated ?? false;
});
