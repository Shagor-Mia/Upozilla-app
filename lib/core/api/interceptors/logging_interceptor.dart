import 'package:dio/dio.dart';

import '../../observability/logger.dart';

/// Section 8.2 step (4): request/response logging, added only in debug builds.
/// Logs method, path, status and duration only — never headers or bodies,
/// which carry bearer tokens, OTP codes and phone numbers.
class DebugLoggingInterceptor extends Interceptor {
  static const _startedAt = 'log.started_at';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAt] = DateTime.now();
    AppLogger.debug('--> ${options.method} ${options.path}', tag: 'http');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      '<-- ${response.statusCode} ${response.requestOptions.path}',
      tag: 'http',
      fields: {'ms': _elapsed(response.requestOptions)},
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.debug(
      '<-x ${err.response?.statusCode ?? err.type.name} ${err.requestOptions.path}',
      tag: 'http',
      fields: {'ms': _elapsed(err.requestOptions)},
    );
    handler.next(err);
  }

  int _elapsed(RequestOptions options) {
    final started = options.extra[_startedAt];
    if (started is! DateTime) return 0;
    return DateTime.now().difference(started).inMilliseconds;
  }
}
