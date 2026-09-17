import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../error/app_exception.dart';
import '../error/dio_error_mapper.dart';
import '../network/connectivity.dart';
import '../storage/token_storage.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/locale_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'session_expiry.dart';
import 'token_refresher.dart';

/// Builds the app's single Dio instance with the Section 8.2 interceptor
/// chain: locale → auth → retry → (debug) logging.
Dio createDio({
  required AppConfig config,
  required TokenStorage tokenStorage,
  required SessionExpiryNotifier sessionExpiry,
  required Ref ref,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json'},
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.addAll([
    LocaleInterceptor(ref: ref),
    AuthInterceptor(
      dio: dio,
      tokenStorage: tokenStorage,
      refresher: TokenRefresher(baseUrl: config.apiBaseUrl),
      sessionExpiry: sessionExpiry,
    ),
    RetryInterceptor(dio: dio),
    if (kDebugMode) DebugLoggingInterceptor(),
  ]);
  return dio;
}

/// Thin typed wrapper over Dio used by every repository. It is the only place
/// that turns [DioException] into [AppException]; presentation code never sees
/// Dio types (Section 20.5).
class ApiClient {
  ApiClient({required Dio dio, required ConnectivityService connectivity})
      : _dio = dio,
        _connectivity = connectivity;

  final Dio _dio;
  final ConnectivityService _connectivity;

  Future<Object?> get(
    String path, {
    Map<String, Object?>? query,
    CancelToken? cancelToken,
  }) {
    return _run(
      () => _dio.get<Object?>(path, queryParameters: _cleanQuery(query), cancelToken: cancelToken),
    );
  }

  Future<Object?> post(
    String path, {
    Object? body,
    bool skipAuth = false,
    CancelToken? cancelToken,
  }) {
    return _run(
      () => _dio.post<Object?>(
        path,
        data: body,
        cancelToken: cancelToken,
        options: Options(extra: {AuthExtra.skipAuth: skipAuth}),
      ),
    );
  }

  Future<Object?> put(
    String path, {
    Object? body,
    CancelToken? cancelToken,
  }) {
    return _run(
      () => _dio.put<Object?>(
        path,
        data: body,
        cancelToken: cancelToken,
        options: Options(extra: {AuthExtra.skipAuth: false}),
      ),
    );
  }

  Future<Object?> patch(
    String path, {
    Object? body,
    CancelToken? cancelToken,
  }) {
    return _run(
      () => _dio.patch<Object?>(
        path,
        data: body,
        cancelToken: cancelToken,
        options: Options(extra: {AuthExtra.skipAuth: false}),
      ),
    );
  }

  Future<Object?> delete(
    String path, {
    Object? body,
    CancelToken? cancelToken,
  }) {
    return _run(
      () => _dio.delete<Object?>(
        path,
        data: body,
        cancelToken: cancelToken,
        options: Options(extra: {AuthExtra.skipAuth: false}),
      ),
    );
  }

  Future<Object?> _run(Future<Response<Object?>> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (e) {
      final offline = _isTransport(e) && await _connectivity.isOffline();
      throw mapDioException(e, isOffline: offline);
    }
  }

  static bool _isTransport(DioException e) =>
      e.type != DioExceptionType.badResponse && e.type != DioExceptionType.cancel;

  static Map<String, Object?>? _cleanQuery(Map<String, Object?>? query) {
    if (query == null) return null;
    final cleaned = <String, Object?>{};
    query.forEach((key, value) {
      if (value != null) cleaned[key] = value;
    });
    return cleaned;
  }
}

/// JSON shape helpers shared by repositories so every decode failure becomes a
/// [ParseException] rather than a raw type error.
Map<String, dynamic> asJsonObject(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((k, v) => MapEntry(k.toString(), v));
  throw const ParseException('Expected a JSON object');
}

List<Map<String, dynamic>> asJsonList(Object? value) {
  if (value is! List) throw const ParseException('Expected a JSON array');
  return value.map(asJsonObject).toList();
}

final dioProvider = Provider<Dio>((ref) {
  return createDio(
    config: ref.watch(appConfigProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
    sessionExpiry: ref.watch(sessionExpiryProvider),
    ref: ref,
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    dio: ref.watch(dioProvider),
    connectivity: ref.watch(connectivityServiceProvider),
  );
});
