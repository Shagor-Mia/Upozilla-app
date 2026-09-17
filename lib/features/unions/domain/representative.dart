import '../../../core/models/json_helpers.dart';

/// `RepresentativeResponse`.
class Representative {
  const Representative({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.locationId,
    required this.locationName,
    required this.position,
    required this.status,
    this.phone,
    this.bio,
    this.photoUrl,
  });

  final String id;
  final String userId;
  final String fullName;

  /// Deliberately unmasked (public citizen-contact directory), unlike seller phones.
  final String? phone;
  final String locationId;
  final String locationName;

  /// `chairman` | `women_member` | `ward_member`
  final String position;
  final String? bio;
  final String? photoUrl;

  /// `active` | `inactive`
  final String status;

  factory Representative.fromJson(Map<String, dynamic> json) => Representative(
        id: json['id'] as String,
        userId: json['user_id'] as String? ?? '',
        fullName: json['full_name'] as String? ?? '',
        phone: readString(json['phone']),
        locationId: json['location_id'] as String? ?? '',
        locationName: json['location_name'] as String? ?? '',
        position: json['position'] as String? ?? 'ward_member',
        bio: readString(json['bio']),
        photoUrl: readString(json['photo_url']),
        status: json['status'] as String? ?? 'active',
      );
}
