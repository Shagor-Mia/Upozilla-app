import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upazila_app/core/error/app_exception.dart';
import 'package:upazila_app/core/error/dio_error_mapper.dart';

DioException _httpError(int status, Object? body, {Map<String, List<String>>? headers}) {
  final options = RequestOptions(path: '/test');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: options,
      statusCode: status,
      data: body,
      headers: Headers.fromMap(headers ?? const {}),
    ),
  );
}

DioException _transportError(DioExceptionType type) =>
    DioException(requestOptions: RequestOptions(path: '/test'), type: type);

void main() {
  group('transport errors', () {
    test('timeouts map to NetworkException when online', () {
      expect(mapDioException(_transportError(DioExceptionType.connectionTimeout)), isA<NetworkException>());
      expect(mapDioException(_transportError(DioExceptionType.receiveTimeout)), isA<NetworkException>());
      expect(mapDioException(_transportError(DioExceptionType.connectionError)), isA<NetworkException>());
    });

    test('become OfflineException when the device is offline', () {
      expect(
        mapDioException(_transportError(DioExceptionType.connectionError), isOffline: true),
        isA<OfflineException>(),
      );
    });

    test('cancel maps to CancelledException', () {
      expect(mapDioException(_transportError(DioExceptionType.cancel)), isA<CancelledException>());
    });
  });

  group('HTTP status mapping', () {
    test('401/403/404/409', () {
      expect(mapDioException(_httpError(401, {'detail': 'Not authenticated'})), isA<UnauthorizedException>());
      expect(mapDioException(_httpError(403, {'detail': 'insufficient permissions'})), isA<ForbiddenException>());
      expect(mapDioException(_httpError(404, {'detail': 'place not found'})), isA<NotFoundException>());
      expect(mapDioException(_httpError(409, {'detail': 'duplicate'})), isA<ConflictException>());
    });

    test('uses the FastAPI detail string as the message', () {
      final error = mapDioException(_httpError(403, {'detail': 'phone verification required'}));
      expect(error.message, 'phone verification required');
    });

    test('422 pydantic errors become field errors', () {
      final body = {
        'detail': [
          {
            'loc': ['body', 'phone'],
            'msg': 'enter a valid Bangladeshi mobile number',
            'type': 'value_error',
          },
          {
            'loc': ['body', 'code'],
            'msg': 'code must be 6 digits',
            'type': 'value_error',
          },
        ],
      };
      final error = mapDioException(_httpError(422, body));
      expect(error, isA<ValidationException>());
      final validation = error as ValidationException;
      expect(validation.fieldError('phone'), 'enter a valid Bangladeshi mobile number');
      expect(validation.fieldError('code'), 'code must be 6 digits');
      expect(validation.message, contains('phone'));
    });

    test('400 with a plain detail is a ValidationException without field errors', () {
      final error = mapDioException(_httpError(400, {'detail': 'full_name is required to register'}));
      expect(error, isA<ValidationException>());
      expect((error as ValidationException).fieldErrors, isEmpty);
      expect(error.message, 'full_name is required to register');
    });

    test('429 reads Retry-After', () {
      final error = mapDioException(
        _httpError(429, {'detail': 'slow down'}, headers: {'retry-after': ['30']}),
      );
      expect(error, isA<RateLimitedException>());
      expect((error as RateLimitedException).retryAfter, const Duration(seconds: 30));
    });

    test('5xx is a ServerException carrying the status', () {
      final error = mapDioException(_httpError(503, null));
      expect(error, isA<ServerException>());
      expect((error as ServerException).statusCode, 503);
    });

    test('unknown 4xx falls back to UnexpectedApiException', () {
      expect(mapDioException(_httpError(418, {'detail': 'teapot'})), isA<UnexpectedApiException>());
    });
  });

  group('extractFieldErrors', () {
    test('handles non-map bodies gracefully', () {
      expect(extractFieldErrors('oops'), isEmpty);
      expect(extractFieldErrors(null), isEmpty);
      expect(extractDetailMessage('oops'), isNull);
    });

    test('joins nested loc segments and drops the body prefix', () {
      final errors = extractFieldErrors({
        'detail': [
          {
            'loc': ['body', 'images', 0],
            'msg': 'invalid url',
          },
        ],
      });
      expect(errors['images.0'], 'invalid url');
    });
  });
}
