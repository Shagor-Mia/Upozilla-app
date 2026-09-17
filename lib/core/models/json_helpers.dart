/// Small lenient readers for hand-written `fromJson` constructors. The backend
/// serialises UUIDs as strings, datetimes as ISO-8601 and `time` as `HH:MM:SS`.
double? readDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? readInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

bool readBool(Object? value, {bool fallback = false}) {
  if (value is bool) return value;
  return fallback;
}

String? readString(Object? value) => value?.toString();

List<String> readStringList(Object? value) {
  if (value is! List) return const [];
  return value.map((e) => e.toString()).toList();
}

DateTime? readDateTime(Object? value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value);
}
