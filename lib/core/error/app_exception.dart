/// Typed error hierarchy (Section 8.2). Every backend/network failure is
/// mapped to one of these so screens handle failures uniformly.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Transport-level failure: DNS, TCP, TLS, timeouts.
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

/// The device reports no connectivity at all; UI shows the offline banner.
class OfflineException extends AppException {
  const OfflineException([super.message = 'You are offline']);
}

/// The request was cancelled by the caller (disposed screen); never shown.
class CancelledException extends AppException {
  const CancelledException([super.message = 'Request cancelled']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Please sign in']);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Not allowed']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found']);
}

class ConflictException extends AppException {
  const ConflictException([super.message = 'Conflict']);
}

/// 400 / 422 with optional per-field messages (Pydantic `loc` → field name).
class ValidationException extends AppException {
  const ValidationException(super.message, {this.fieldErrors = const {}});

  final Map<String, String> fieldErrors;

  String? fieldError(String field) => fieldErrors[field];
}

class RateLimitedException extends AppException {
  const RateLimitedException({this.retryAfter, String message = 'Too many requests'})
      : super(message);

  final Duration? retryAfter;
}

class ServerException extends AppException {
  const ServerException({this.statusCode, String message = 'Server error'}) : super(message);

  final int? statusCode;
}

/// Any other HTTP error status the app has no dedicated handling for.
class UnexpectedApiException extends AppException {
  const UnexpectedApiException({this.statusCode, String message = 'Unexpected error'})
      : super(message);

  final int? statusCode;
}

/// Response body could not be decoded into the expected shape.
class ParseException extends AppException {
  const ParseException([super.message = 'Unexpected response format']);
}

/// Device location could not be obtained (permission/service state).
class LocationException extends AppException {
  const LocationException(super.message, {required this.reason});

  final LocationFailureReason reason;
}

enum LocationFailureReason { serviceDisabled, permissionDenied, permissionDeniedForever, unavailable }
