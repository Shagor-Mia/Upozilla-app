import 'package:dio/dio.dart';

import '../../observability/logger.dart';
import '../../storage/token_storage.dart';
import '../session_expiry.dart';
import '../token_refresher.dart';

/// Request `extra` flags understood by [AuthInterceptor].
class AuthExtra {
  const AuthExtra._();

  /// Set on requests that must not carry a bearer token (OTP, login, refresh).
  static const skipAuth = 'auth.skip';

  /// Marks a replayed request so a second 401 is not refreshed again.
  static const replayed = 'auth.replayed';
}

/// Section 8.2 steps (1) and (2): attach the access token; on 401 refresh once
/// (single-flight across concurrent requests), replay the original request,
/// and only if the refresh itself fails force a logout.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required TokenRefresher refresher,
    required SessionExpiryNotifier sessionExpiry,
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _refresher = refresher,
        _sessionExpiry = sessionExpiry;

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final TokenRefresher _refresher;
  final SessionExpiryNotifier _sessionExpiry;

  Future<String?>? _refreshInFlight;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra[AuthExtra.skipAuth] == true) {
      handler.next(options);
      return;
    }
    final token = await _tokenStorage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    if (!isUnauthorized ||
        options.extra[AuthExtra.skipAuth] == true ||
        options.extra[AuthExtra.replayed] == true) {
      handler.next(err);
      return;
    }

    final newAccessToken = await _accessTokenAfterRefresh(options);
    if (newAccessToken == null) {
      handler.next(err);
      return;
    }

    options.headers['Authorization'] = 'Bearer $newAccessToken';
    options.extra[AuthExtra.replayed] = true;
    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (replayError) {
      handler.next(replayError);
    }
  }

  /// Returns a usable access token, refreshing at most once at a time. If
  /// another request already rotated the token, reuse it without refreshing.
  Future<String?> _accessTokenAfterRefresh(RequestOptions failed) async {
    final usedHeader = failed.headers['Authorization'];
    final current = await _tokenStorage.readAccessToken();
    if (current != null && 'Bearer $current' != usedHeader) {
      return current;
    }
    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final future = _refresh().whenComplete(() => _refreshInFlight = null);
    _refreshInFlight = future;
    return future;
  }

  Future<String?> _refresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null) {
      _sessionExpiry.notifyExpired();
      return null;
    }
    try {
      final tokens = await _refresher.refresh(refreshToken);
      await _tokenStorage.saveTokens(tokens);
      AppLogger.info('access token refreshed', tag: 'auth');
      return tokens.accessToken;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      // Transport failures keep the session; only a definitive rejection ends it.
      if (status != null && status >= 400 && status < 500) {
        AppLogger.warn('refresh rejected, forcing logout', tag: 'auth', fields: {'status': status});
        await _tokenStorage.clear();
        _sessionExpiry.notifyExpired();
      } else {
        AppLogger.warn('refresh failed transiently', tag: 'auth', fields: {'type': e.type.name});
      }
      return null;
    }
  }
}
