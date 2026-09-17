import 'dart:math' as math;

import 'package:dio/dio.dart';

import '../../observability/logger.dart';

/// Request `extra` flags understood by [RetryInterceptor].
class RetryExtra {
  const RetryExtra._();

  /// Opt a non-GET request into retries (only when the endpoint is idempotent).
  static const idempotent = 'retry.idempotent';

  static const attempt = 'retry.attempt';
}

/// Section 8.2 step (3): capped exponential backoff for transient failures on
/// idempotent requests only. POSTs such as "create listing" are never retried.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 3,
    this.baseDelay = const Duration(milliseconds: 400),
    this.maxDelay = const Duration(seconds: 4),
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;

  static const _idempotentMethods = {'GET', 'HEAD', 'OPTIONS'};

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final attempt = (options.extra[RetryExtra.attempt] as int?) ?? 0;
    if (!_isRetryable(err) || attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    final delay = _delayFor(attempt);
    AppLogger.debug(
      'retrying ${options.method} ${options.path}',
      tag: 'retry',
      fields: {'attempt': attempt + 1, 'delayMs': delay.inMilliseconds},
    );
    await Future<void>.delayed(delay);
    if (options.cancelToken?.isCancelled ?? false) {
      handler.next(err);
      return;
    }

    options.extra[RetryExtra.attempt] = attempt + 1;
    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _isRetryable(DioException err) {
    final options = err.requestOptions;
    final idempotent = _idempotentMethods.contains(options.method.toUpperCase()) ||
        options.extra[RetryExtra.idempotent] == true;
    if (!idempotent) return false;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        return status >= 500 && status != 501;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.unknown:
        return false;
    }
  }

  Duration _delayFor(int attempt) {
    final exponential = baseDelay.inMilliseconds * math.pow(2, attempt).toInt();
    final jitter = math.Random().nextInt(100);
    return Duration(milliseconds: math.min(exponential + jitter, maxDelay.inMilliseconds));
  }
}
