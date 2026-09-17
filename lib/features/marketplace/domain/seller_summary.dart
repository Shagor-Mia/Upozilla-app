import '../../../core/models/json_helpers.dart';

/// `SellerSummary` embedded in listing responses. Phone is masked server-side
/// (Section 14.4); the full number comes from the rate-limited contact endpoint.
class SellerSummary {
  const SellerSummary({
    required this.id,
    required this.fullName,
    required this.phoneVerified,
    required this.trustScore,
    required this.reviewCount,
    this.phoneMasked,
    this.memberSince,
    this.avgRating,
  });

  final String id;
  final String fullName;
  final String? phoneMasked;
  final bool phoneVerified;
  final DateTime? memberSince;
  final int trustScore;
  final double? avgRating;
  final int reviewCount;

  factory SellerSummary.fromJson(Map<String, dynamic> json) => SellerSummary(
        id: json['id'] as String,
        fullName: json['full_name'] as String? ?? '',
        phoneMasked: readString(json['phone_masked']),
        phoneVerified: readBool(json['phone_verified']),
        memberSince: readDateTime(json['member_since']),
        trustScore: readInt(json['trust_score']) ?? 0,
        avgRating: readDouble(json['avg_rating']),
        reviewCount: readInt(json['review_count']) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'phone_masked': phoneMasked,
        'phone_verified': phoneVerified,
        'member_since': memberSince?.toIso8601String(),
        'trust_score': trustScore,
        'avg_rating': avgRating,
        'review_count': reviewCount,
      };
}
