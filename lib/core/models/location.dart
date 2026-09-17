/// `LocationResponse` — Division -> District -> Upazila -> Union -> Village,
/// self-referential via `parent_id`. Cross-feature (used by the marketplace
/// sell form's location picker and any future location-scoped screen), so it
/// lives in `core/` rather than inside a single feature (Section 20.8).
class AppLocation {
  const AppLocation({
    required this.id,
    required this.type,
    required this.name,
    this.parentId,
  });

  final String id;

  /// `division` | `district` | `upazila` | `union` | `village`
  final String type;
  final String name;
  final String? parentId;

  factory AppLocation.fromJson(Map<String, dynamic> json) => AppLocation(
        id: json['id'] as String,
        type: json['type'] as String? ?? '',
        name: json['name'] as String? ?? '',
        parentId: json['parent_id'] as String?,
      );

  /// "Homna (Upazila)" / "Bara Ichhapura (Union)" — the same suffix format
  /// `frontend/lib/locations.ts` uses, so a name that repeats at another
  /// administrative level (e.g. a union sharing its upazila's name) still
  /// reads unambiguously in a flat dropdown.
  String get displayLabel {
    switch (type) {
      case 'upazila':
        return '$name (Upazila)';
      case 'union':
        return '$name (Union)';
      default:
        return name;
    }
  }
}
