import '../../../core/api/api_client.dart' show asJsonList;
import '../../../core/models/json_helpers.dart';

/// Slim local projections of `RecommendationsResponse` (Section 17 Phase 4)
/// for the home screen's "For You" section - kept local to the home feature
/// so it does not import domain models from `features/marketplace`/
/// `features/explore` (same reasoning as [FeaturedPlace]: Section 8.8,
/// features never import each other).
class RecommendedListing {
  const RecommendedListing({
    required this.id,
    required this.listingType,
    required this.title,
    required this.price,
    required this.currency,
    required this.locationName,
    required this.condition,
    this.imageUrl,
    this.isNegotiable = false,
  });

  final String id;

  /// `marketplace` | `exchange`
  final String listingType;
  final String title;
  final double price;
  final String currency;
  final String locationName;
  final String condition;
  final String? imageUrl;
  final bool isNegotiable;

  factory RecommendedListing.fromJson(Map<String, dynamic> json, {required String listingType}) =>
      RecommendedListing(
        id: json['id'] as String,
        listingType: listingType,
        title: json['title'] as String? ?? '',
        price: readDouble(json['price']) ?? 0,
        currency: json['currency'] as String? ?? 'BDT',
        locationName: json['location_name'] as String? ?? '',
        condition: json['condition'] as String? ?? 'used',
        imageUrl: (readStringList(json['images']).isNotEmpty) ? readStringList(json['images']).first : null,
        isNegotiable: readBool(json['is_negotiable']),
      );
}

class RecommendedHospital {
  const RecommendedHospital({required this.id, required this.name, this.address});

  final String id;
  final String name;
  final String? address;

  factory RecommendedHospital.fromJson(Map<String, dynamic> json) => RecommendedHospital(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        address: readString(json['address']),
      );
}

class Recommendations {
  const Recommendations({required this.listings, required this.hospitals});

  final List<RecommendedListing> listings;
  final List<RecommendedHospital> hospitals;

  factory Recommendations.fromJson(Map<String, dynamic> json) {
    final products = asJsonList(json['trending_products'])
        .map((e) => RecommendedListing.fromJson(e, listingType: 'marketplace'))
        .toList();
    final exchange = asJsonList(json['trending_exchange'])
        .map((e) => RecommendedListing.fromJson(e, listingType: 'exchange'))
        .toList();
    return Recommendations(
      listings: [...products, ...exchange],
      hospitals: asJsonList(json['hospitals']).map(RecommendedHospital.fromJson).toList(),
    );
  }
}
