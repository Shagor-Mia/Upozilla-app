import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Access/refresh JWT pair as returned by `/auth/*` token endpoints.
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        'token_type': 'bearer',
      };
}

/// Secure storage wrapper for the JWT pair (Section 9: flutter_secure_storage).
/// Tokens are the only thing kept here; user profile data lives in memory.
class TokenStorage {
  TokenStorage([FlutterSecureStorage? storage])
      : _storage = storage ??
            // flutter_secure_storage >= 10 always uses EncryptedSharedPreferences on
            // Android, so no per-platform options are needed here.
            const FlutterSecureStorage();

  static const _accessKey = 'auth.access_token';
  static const _refreshKey = 'auth.refresh_token';

  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<AuthTokens?> readTokens() async {
    final access = await readAccessToken();
    final refresh = await readRefreshToken();
    if (access == null || refresh == null) return null;
    return AuthTokens(accessToken: access, refreshToken: refresh);
  }

  Future<void> saveTokens(AuthTokens tokens) async {
    await _storage.write(key: _accessKey, value: tokens.accessToken);
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());
