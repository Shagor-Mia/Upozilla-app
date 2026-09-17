import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'api_paths.dart';

/// Exchanges a refresh token for a new pair using a bare Dio instance so the
/// call never re-enters the auth/retry interceptor chain.
class TokenRefresher {
  TokenRefresher({required String baseUrl, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 15),
              ),
            );

  final Dio _dio;

  /// Throws [DioException] on failure; callers decide whether that means the
  /// session is dead (4xx) or the network is flaky (transport error).
  Future<AuthTokens> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiPaths.authRefresh,
      data: {'refresh_token': refreshToken},
    );
    final data = response.data;
    if (data == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'Empty refresh response',
      );
    }
    return AuthTokens.fromJson(data);
  }
}
