import 'package:intl/intl.dart';

/// Locale-aware formatting helpers. Decision (Section 8.4): numbers, prices
/// and distances are rendered with Latin digits in both locales so they match
/// the web app and listing text users type themselves; only dates/month names
/// follow the active locale.
class Formatters {
  const Formatters._();

  static String price(num amount, {String currency = 'BDT'}) {
    final symbol = currency.toUpperCase() == 'BDT' ? '৳' : '$currency ';
    final formatted = NumberFormat('#,##0.##', 'en').format(amount);
    return '$symbol$formatted';
  }

  static String distanceKm(double km) {
    if (km < 1) return '${(km * 1000).round()} m';
    return '${km.toStringAsFixed(km < 10 ? 1 : 0)} km';
  }

  static String date(DateTime value, {String? locale}) =>
      DateFormat.yMMMd(locale).format(value.toLocal());

  static String dateTime(DateTime value, {String? locale}) =>
      DateFormat.yMMMd(locale).add_jm().format(value.toLocal());

  /// Backend `time` fields arrive as `HH:MM:SS`; show `HH:MM`.
  static String clock(String? hhmmss) {
    if (hhmmss == null || hhmmss.isEmpty) return '';
    final parts = hhmmss.split(':');
    if (parts.length < 2) return hhmmss;
    return '${parts[0]}:${parts[1]}';
  }

  /// `some_enum_value` → `Some enum value`.
  static String humanize(String raw) {
    if (raw.isEmpty) return raw;
    final spaced = raw.replaceAll('_', ' ');
    return spaced[0].toUpperCase() + spaced.substring(1);
  }
}
