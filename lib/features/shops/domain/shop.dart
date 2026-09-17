import '../../../core/models/json_helpers.dart';

/// `ShopCategoryResponse`.
class ShopCategory {
  const ShopCategory({required this.id, required this.name, required this.slug, this.icon, this.sortOrder = 0});

  final String id;
  final String name;
  final String slug;
  final String? icon;
  final int sortOrder;

  factory ShopCategory.fromJson(Map<String, dynamic> json) => ShopCategory(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        icon: readString(json['icon']),
        sortOrder: readInt(json['sort_order']) ?? 0,
      );
}

/// Trimmed `SellerSummary` (only the fields the shop detail screen shows).
class ShopSeller {
  const ShopSeller({required this.id, required this.fullName, required this.phoneVerified});

  final String id;
  final String fullName;
  final bool phoneVerified;

  factory ShopSeller.fromJson(Map<String, dynamic> json) => ShopSeller(
        id: json['id'] as String,
        fullName: json['full_name'] as String? ?? '',
        phoneVerified: readBool(json['phone_verified']),
      );
}

/// `ShopResponse`.
class Shop {
  const Shop({
    required this.id,
    required this.marketId,
    required this.marketName,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.images,
    required this.isFeatured,
    required this.status,
    required this.moderationStatus,
    required this.seller,
    this.description,
    this.contactPhone,
    this.createdAt,
  });

  final String id;
  final String marketId;
  final String marketName;
  final String categoryId;
  final String categoryName;
  final String name;
  final String? description;
  final String? contactPhone;
  final List<String> images;
  final bool isFeatured;

  /// `active` | `hidden`
  final String status;

  /// `pending` | `approved` | `rejected`
  final String moderationStatus;
  final DateTime? createdAt;
  final ShopSeller seller;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        id: json['id'] as String,
        marketId: json['market_id'] as String? ?? '',
        marketName: json['market_name'] as String? ?? '',
        categoryId: json['category_id'] as String? ?? '',
        categoryName: json['category_name'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: readString(json['description']),
        contactPhone: readString(json['contact_phone']),
        images: readStringList(json['images']),
        isFeatured: readBool(json['is_featured']),
        status: json['status'] as String? ?? 'active',
        moderationStatus: json['moderation_status'] as String? ?? 'pending',
        createdAt: readDateTime(json['created_at']),
        seller: ShopSeller.fromJson(asJsonObjectOrEmpty(json['seller'])),
      );
}

Map<String, dynamic> asJsonObjectOrEmpty(Object? value) => value is Map<String, dynamic> ? value : const {};
