import '../../../core/models/json_helpers.dart';
import 'seller_summary.dart';

/// `ExchangeListingResponse` — C2C classifieds listing.
class ExchangeListing {
  const ExchangeListing({
    required this.id,
    required this.sellerUserId,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.price,
    required this.currency,
    required this.isNegotiable,
    required this.condition,
    required this.images,
    required this.locationId,
    required this.locationName,
    required this.status,
    required this.moderationStatus,
    required this.seller,
    this.listingType = 'exchange',
    this.description,
    this.latitude,
    this.longitude,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
    this.isFavorited = false,
    this.favoritesCount = 0,
  });

  final String id;
  final String listingType;
  final String sellerUserId;
  final String categoryId;
  final String categoryName;
  final String title;
  final String? description;
  final double price;
  final String currency;
  final bool isNegotiable;

  /// `new` | `used`
  final String condition;
  final List<String> images;
  final String locationId;
  final String locationName;
  final double? latitude;
  final double? longitude;
  final String status;
  final String moderationStatus;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SellerSummary seller;
  final bool isFavorited;
  final int favoritesCount;

  String? get coverImage => images.isEmpty ? null : images.first;

  factory ExchangeListing.fromJson(Map<String, dynamic> json) => ExchangeListing(
        id: json['id'] as String,
        listingType: json['listing_type'] as String? ?? 'exchange',
        sellerUserId: json['seller_user_id'] as String? ?? '',
        categoryId: json['category_id'] as String? ?? '',
        categoryName: json['category_name'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: readString(json['description']),
        price: readDouble(json['price']) ?? 0,
        currency: json['currency'] as String? ?? 'BDT',
        isNegotiable: readBool(json['is_negotiable']),
        condition: json['condition'] as String? ?? 'used',
        images: readStringList(json['images']),
        locationId: json['location_id'] as String? ?? '',
        locationName: json['location_name'] as String? ?? '',
        latitude: readDouble(json['latitude']),
        longitude: readDouble(json['longitude']),
        status: json['status'] as String? ?? 'active',
        moderationStatus: json['moderation_status'] as String? ?? 'approved',
        expiresAt: readDateTime(json['expires_at']),
        createdAt: readDateTime(json['created_at']),
        updatedAt: readDateTime(json['updated_at']),
        seller: SellerSummary.fromJson(json['seller'] as Map<String, dynamic>),
        isFavorited: readBool(json['is_favorited']),
        favoritesCount: readInt(json['favorites_count']) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'listing_type': listingType,
        'seller_user_id': sellerUserId,
        'category_id': categoryId,
        'category_name': categoryName,
        'title': title,
        'description': description,
        'price': price,
        'currency': currency,
        'is_negotiable': isNegotiable,
        'condition': condition,
        'images': images,
        'location_id': locationId,
        'location_name': locationName,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'moderation_status': moderationStatus,
        'expires_at': expiresAt?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'seller': seller.toJson(),
        'is_favorited': isFavorited,
        'favorites_count': favoritesCount,
      };

  ExchangeListing copyWith({bool? isFavorited, int? favoritesCount, String? status}) => ExchangeListing(
        id: id,
        listingType: listingType,
        sellerUserId: sellerUserId,
        categoryId: categoryId,
        categoryName: categoryName,
        title: title,
        description: description,
        price: price,
        currency: currency,
        isNegotiable: isNegotiable,
        condition: condition,
        images: images,
        locationId: locationId,
        locationName: locationName,
        latitude: latitude,
        longitude: longitude,
        status: status ?? this.status,
        moderationStatus: moderationStatus,
        expiresAt: expiresAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        seller: seller,
        isFavorited: isFavorited ?? this.isFavorited,
        favoritesCount: favoritesCount ?? this.favoritesCount,
      );
}
