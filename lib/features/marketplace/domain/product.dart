import '../../../core/models/json_helpers.dart';
import 'seller_summary.dart';

/// `ProductResponse` — Local Bazar (business/B2C) listing.
class Product {
  const Product({
    required this.id,
    required this.sellerUserId,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.price,
    required this.currency,
    required this.condition,
    required this.images,
    required this.locationId,
    required this.locationName,
    required this.status,
    required this.moderationStatus,
    required this.seller,
    this.listingType = 'marketplace',
    this.businessId,
    this.businessName,
    this.businessSlug,
    this.description,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.isFavorited = false,
    this.favoritesCount = 0,
  });

  final String id;
  final String listingType;
  final String? businessId;
  final String? businessName;
  final String? businessSlug;
  final String sellerUserId;
  final String categoryId;
  final String categoryName;
  final String title;
  final String? description;
  final double price;
  final String currency;

  /// `new` | `used`
  final String condition;
  final List<String> images;
  final String locationId;
  final String locationName;
  final double? latitude;
  final double? longitude;
  final String status;
  final String moderationStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final SellerSummary seller;
  final bool isFavorited;
  final int favoritesCount;

  String? get coverImage => images.isEmpty ? null : images.first;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        listingType: json['listing_type'] as String? ?? 'marketplace',
        businessId: readString(json['business_id']),
        businessName: readString(json['business_name']),
        businessSlug: readString(json['business_slug']),
        sellerUserId: json['seller_user_id'] as String? ?? '',
        categoryId: json['category_id'] as String? ?? '',
        categoryName: json['category_name'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: readString(json['description']),
        price: readDouble(json['price']) ?? 0,
        currency: json['currency'] as String? ?? 'BDT',
        condition: json['condition'] as String? ?? 'new',
        images: readStringList(json['images']),
        locationId: json['location_id'] as String? ?? '',
        locationName: json['location_name'] as String? ?? '',
        latitude: readDouble(json['latitude']),
        longitude: readDouble(json['longitude']),
        status: json['status'] as String? ?? 'active',
        moderationStatus: json['moderation_status'] as String? ?? 'approved',
        createdAt: readDateTime(json['created_at']),
        updatedAt: readDateTime(json['updated_at']),
        seller: SellerSummary.fromJson(json['seller'] as Map<String, dynamic>),
        isFavorited: readBool(json['is_favorited']),
        favoritesCount: readInt(json['favorites_count']) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'listing_type': listingType,
        'business_id': businessId,
        'business_name': businessName,
        'business_slug': businessSlug,
        'seller_user_id': sellerUserId,
        'category_id': categoryId,
        'category_name': categoryName,
        'title': title,
        'description': description,
        'price': price,
        'currency': currency,
        'condition': condition,
        'images': images,
        'location_id': locationId,
        'location_name': locationName,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'moderation_status': moderationStatus,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'seller': seller.toJson(),
        'is_favorited': isFavorited,
        'favorites_count': favoritesCount,
      };

  Product copyWith({bool? isFavorited, int? favoritesCount, String? status}) => Product(
        id: id,
        listingType: listingType,
        businessId: businessId,
        businessName: businessName,
        businessSlug: businessSlug,
        sellerUserId: sellerUserId,
        categoryId: categoryId,
        categoryName: categoryName,
        title: title,
        description: description,
        price: price,
        currency: currency,
        condition: condition,
        images: images,
        locationId: locationId,
        locationName: locationName,
        latitude: latitude,
        longitude: longitude,
        status: status ?? this.status,
        moderationStatus: moderationStatus,
        createdAt: createdAt,
        updatedAt: updatedAt,
        seller: seller,
        isFavorited: isFavorited ?? this.isFavorited,
        favoritesCount: favoritesCount ?? this.favoritesCount,
      );
}
