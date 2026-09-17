/// Bangladeshi mobile number normalisation mirroring the backend's
/// `normalize_bd_phone`: accepts `01XXXXXXXXX`, `+8801…`, `8801…` with spaces,
/// dashes or parentheses, and returns E.164 (`+8801XXXXXXXXX`).
///
/// Returns null when the input is not a valid BD mobile number so the form
/// can show an inline error before hitting the API.
String? normalizeBdPhone(String raw) {
  var digits = raw.trim().replaceAll(RegExp(r'[\s\-()]'), '');
  if (digits.startsWith('+880')) {
    digits = digits.substring(3);
  } else if (digits.startsWith('880')) {
    digits = digits.substring(2);
  } else if (digits.startsWith('+')) {
    return null;
  }
  if (!_bdMobile.hasMatch(digits)) return null;
  return '+88$digits';
}

final RegExp _bdMobile = RegExp(r'^01[3-9]\d{8}$');

/// `+8801712345678` → `+88017****678` — for display only (Section 14.4).
String maskPhone(String phone) {
  if (phone.length < 8) return '*' * phone.length;
  return '${phone.substring(0, 6)}****${phone.substring(phone.length - 3)}';
}
