import 'package:dio/dio.dart';

import 'app_exception.dart';

/// Maps a [DioException] (and the FastAPI error envelope inside it) to the
/// typed [AppException] hierarchy. Pure function so it is unit-testable.
///
/// FastAPI shapes handled:
///  * `{"detail": "message"}` for HTTPException
///  * `{"detail": [{"loc": ["body", "field"], "msg": "...", "type": "..."}]}` for 422
AppException mapDioException(DioException error, {bool isOffline = false}) {
  switch (error.type) {
    case DioExceptionType.cancel:
      return const CancelledException();
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.badCertificate:
      return isOffline ? const OfflineException() : NetworkException(_transportMessage(error.type));
    case DioExceptionType.badResponse:
      return mapHttpResponse(error.response?.statusCode, error.response?.data, error.response?.headers);
    case DioExceptionType.unknown:
      // Dio wraps SocketException/HandshakeException as `unknown` on some platforms.
      return isOffline ? const OfflineException() : const NetworkException();
  }
}

AppException mapHttpResponse(int? statusCode, Object? body, Headers? headers) {
  final detail = extractDetailMessage(body);
  switch (statusCode) {
    case 400:
      return ValidationException(detail ?? 'Invalid request', fieldErrors: extractFieldErrors(body));
    case 401:
      return UnauthorizedException(detail ?? 'Please sign in');
    case 403:
      return ForbiddenException(detail ?? 'Not allowed');
    case 404:
      return NotFoundException(detail ?? 'Not found');
    case 409:
      return ConflictException(detail ?? 'Conflict');
    case 422:
      return ValidationException(detail ?? 'Validation failed', fieldErrors: extractFieldErrors(body));
    case 429:
      return RateLimitedException(retryAfter: _retryAfter(headers), message: detail ?? 'Too many requests');
  }
  if (statusCode != null && statusCode >= 500) {
    return ServerException(statusCode: statusCode, message: detail ?? 'Server error');
  }
  return UnexpectedApiException(statusCode: statusCode, message: detail ?? 'Unexpected error');
}

/// Returns a human-readable message from the FastAPI `detail` field, or null.
String? extractDetailMessage(Object? body) {
  if (body is! Map) return null;
  final detail = body['detail'];
  if (detail is String && detail.isNotEmpty) return detail;
  if (detail is List && detail.isNotEmpty) {
    final first = detail.first;
    if (first is Map) {
      final msg = first['msg'];
      final field = _fieldName(first['loc']);
      if (msg is String) return field == null ? msg : '$field: $msg';
    }
  }
  return null;
}

/// Flattens Pydantic's `loc`/`msg` list into `{field: message}`.
Map<String, String> extractFieldErrors(Object? body) {
  if (body is! Map) return const {};
  final detail = body['detail'];
  if (detail is! List) return const {};
  final result = <String, String>{};
  for (final item in detail) {
    if (item is! Map) continue;
    final field = _fieldName(item['loc']);
    final msg = item['msg'];
    if (field != null && msg is String && !result.containsKey(field)) {
      result[field] = msg;
    }
  }
  return result;
}

String? _fieldName(Object? loc) {
  if (loc is! List || loc.isEmpty) return null;
  // Skip the leading "body"/"query"/"path" segment when present.
  final parts = loc.map((e) => e.toString()).toList();
  if (parts.length > 1 && const {'body', 'query', 'path', 'header'}.contains(parts.first)) {
    parts.removeAt(0);
  }
  return parts.join('.');
}

Duration? _retryAfter(Headers? headers) {
  final raw = headers?.value('retry-after');
  if (raw == null) return null;
  final seconds = int.tryParse(raw.trim());
  return seconds == null ? null : Duration(seconds: seconds);
}

String _transportMessage(DioExceptionType type) {
  switch (type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'The server took too long to respond';
    case DioExceptionType.badCertificate:
      return 'Secure connection failed';
    default:
      return 'Could not reach the server';
  }
}
