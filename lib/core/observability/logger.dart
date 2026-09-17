import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

enum LogLevel { debug, info, warn, error }

/// Structured logger gated by build mode (Section 8.5): verbose in debug,
/// error-only in release (forwarded to Sentry when it is enabled).
///
/// Callers must never pass tokens, OTP codes or phone numbers in messages or
/// fields, even in debug builds.
class AppLogger {
  const AppLogger._();

  static void debug(String message, {String? tag, Map<String, Object?>? fields}) =>
      _log(LogLevel.debug, message, tag: tag, fields: fields);

  static void info(String message, {String? tag, Map<String, Object?>? fields}) =>
      _log(LogLevel.info, message, tag: tag, fields: fields);

  static void warn(String message, {String? tag, Map<String, Object?>? fields}) =>
      _log(LogLevel.warn, message, tag: tag, fields: fields);

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?>? fields,
  }) {
    _log(LogLevel.error, message, tag: tag, fields: fields, error: error, stackTrace: stackTrace);
    if (!kDebugMode && error != null && Sentry.isEnabled) {
      // Fire-and-forget: reporting must never block or crash the caller.
      Sentry.captureException(error, stackTrace: stackTrace).ignore();
    }
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Map<String, Object?>? fields,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode && level != LogLevel.error) return;
    final buffer = StringBuffer('[${level.name.toUpperCase()}]');
    if (tag != null) buffer.write('[$tag]');
    buffer.write(' $message');
    if (fields != null && fields.isNotEmpty) {
      buffer.write(' ${_formatFields(fields)}');
    }
    developer.log(
      buffer.toString(),
      name: 'upazila',
      level: _developerLevel(level),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String _formatFields(Map<String, Object?> fields) =>
      fields.entries.map((e) => '${e.key}=${e.value}').join(' ');

  static int _developerLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warn:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}
