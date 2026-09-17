import 'package:url_launcher/url_launcher.dart';

import '../observability/logger.dart';

/// Opens phone dialer / browser links. Failures are logged, never thrown, so
/// a bad URL in content does not crash a detail screen.
class ExternalLinks {
  const ExternalLinks._();

  static Future<void> dial(String phone) => _open(Uri(scheme: 'tel', path: phone));

  static Future<void> openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await _open(uri, mode: LaunchMode.externalApplication);
  }

  static Future<void> _open(Uri uri, {LaunchMode mode = LaunchMode.platformDefault}) async {
    try {
      final ok = await launchUrl(uri, mode: mode);
      if (!ok) AppLogger.warn('could not launch ${uri.scheme} link', tag: 'links');
    } catch (e, st) {
      AppLogger.error('launchUrl failed', tag: 'links', error: e, stackTrace: st);
    }
  }
}
