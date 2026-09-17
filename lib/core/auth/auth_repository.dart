import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/api_paths.dart';
import '../error/app_exception.dart';
import '../observability/logger.dart';
import '../storage/token_storage.dart';
import 'app_user.dart';
import 'otp.dart';

/// Talks to `/auth/*` and owns the stored token pair. Every call that issues
/// tokens persists them here so the interceptor chain picks them up.
class AuthRepository {
  AuthRepository({required ApiClient api, required TokenStorage tokens})
      : _api = api,
        _tokens = tokens;

  final ApiClient _api;
  final TokenStorage _tokens;

  Future<bool> hasSession() async => await _tokens.readRefreshToken() != null;

  Future<OtpRequestResult> requestOtp({required String phone, required OtpPurpose purpose}) async {
    // `verify_phone` requires the caller to already be signed in (the backend
    // 401s without a bearer token attached), so it must not skip auth.
    final json = await _api.post(
      ApiPaths.authOtpRequest,
      body: {'phone': phone, 'purpose': purpose.apiValue},
      skipAuth: purpose != OtpPurpose.verifyPhone,
    );
    return OtpRequestResult.fromJson(asJsonObject(json));
  }

  Future<void> verifyOtp({
    required String phone,
    required String code,
    required OtpPurpose purpose,
    String? fullName,
  }) async {
    final json = await _api.post(
      ApiPaths.authOtpVerify,
      body: {
        'phone': phone,
        'code': code,
        'purpose': purpose.apiValue,
        if (fullName != null && fullName.isNotEmpty) 'full_name': fullName,
      },
      // `verify_phone` requires a bearer token too (`current_user is None` 401s
      // server-side) - only login/register are anonymous.
      skipAuth: purpose != OtpPurpose.verifyPhone,
    );
    await _tokens.saveTokens(AuthTokens.fromJson(asJsonObject(json)));
  }

  /// Backend `LoginRequest` takes `identifier` (email or phone) + `password`.
  Future<void> loginWithPassword({required String identifier, required String password}) async {
    final json = await _api.post(
      ApiPaths.authLogin,
      body: {'identifier': identifier, 'password': password},
      skipAuth: true,
    );
    await _tokens.saveTokens(AuthTokens.fromJson(asJsonObject(json)));
  }

  Future<AppUser> me() async {
    final json = await _api.get(ApiPaths.authMe);
    return AppUser.fromJson(asJsonObject(json));
  }

  /// Revokes the refresh token server-side (best effort) and always clears
  /// local tokens, so sign-out works offline too.
  Future<void> logout() async {
    final refreshToken = await _tokens.readRefreshToken();
    if (refreshToken != null) {
      try {
        await _api.post(ApiPaths.authLogout, body: {'refresh_token': refreshToken});
      } on AppException catch (e) {
        AppLogger.warn('server logout failed; clearing local session anyway', tag: 'auth', fields: {'reason': e.runtimeType});
      }
    }
    await _tokens.clear();
  }

  Future<void> clearSession() => _tokens.clear();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(api: ref.watch(apiClientProvider), tokens: ref.watch(tokenStorageProvider));
});
