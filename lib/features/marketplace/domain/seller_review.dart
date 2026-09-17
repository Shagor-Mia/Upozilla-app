import '../../../core/models/json_helpers.dart';
import 'seller_summary.dart';

/// `SellerReviewResponse`.
class SellerReview {
  const SellerReview({
    required this.id,
    required this.sellerUserId,
    required this.reviewerUserId,
    required this.reviewerName,
    required this.rating,
    this.listingType,
    this.listingId,
    this.comment,
    this.createdAt,
  });

  final String id;
  final String sellerUserId;
  final String reviewerUserId;
  final String reviewerName;
  final String? listingType;
  final String? listingId;
  final int rating;
  final String? comment;
  final DateTime? createdAt;

  factory SellerReview.fromJson(Map<String, dynamic> json) => SellerReview(
        id: json['id'] as String,
        sellerUserId: json['seller_user_id'] as String? ?? '',
        reviewerUserId: json['reviewer_user_id'] as String? ?? '',
        reviewerName: json['reviewer_name'] as String? ?? '',
        listingType: readString(json['listing_type']),
        listingId: readString(json['listing_id']),
        rating: readInt(json['rating']) ?? 0,
        comment: readString(json['comment']),
        createdAt: readDateTime(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'seller_user_id': sellerUserId,
        'reviewer_user_id': reviewerUserId,
        'reviewer_name': reviewerName,
        'listing_type': listingType,
        'listing_id': listingId,
        'rating': rating,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
      };
}

/// `SellerProfileResponse` — `SellerSummary` plus listing counts and reviews.
class SellerProfile {
  const SellerProfile({
    required this.summary,
    required this.activeListings,
    required this.totalListings,
    required this.reviews,
  });

  final SellerSummary summary;
  final int activeListings;
  final int totalListings;
  final List<SellerReview> reviews;

  factory SellerProfile.fromJson(Map<String, dynamic> json) => SellerProfile(
        summary: SellerSummary.fromJson(json),
        activeListings: readInt(json['active_listings']) ?? 0,
        totalListings: readInt(json['total_listings']) ?? 0,
        reviews: (json['reviews'] as List<dynamic>? ?? const [])
            .map((e) => SellerReview.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
