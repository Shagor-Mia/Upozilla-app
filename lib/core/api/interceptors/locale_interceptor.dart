import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/locale_controller.dart';

/// Tells the backend which language to resolve content into (Section 5:
/// content localization) — mirrors [AuthInterceptor]'s shape, reading the
/// current locale per-request rather than watching it, so a language switch
/// mid-session doesn't force-rebuild the whole Dio/interceptor chain.
class LocaleInterceptor extends Interceptor {
  LocaleInterceptor({required Ref ref}) : _ref = ref;

  final Ref _ref;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final languageCode = _ref.read(localeControllerProvider).languageCode;
    options.headers['Accept-Language'] = languageCode;
    handler.next(options);
  }
}
