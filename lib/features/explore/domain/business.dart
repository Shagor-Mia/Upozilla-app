import '../../../core/models/json_helpers.dart';

/// `BusinessResponse` (+ `distance_km` for "near me").
class Business {
  const Business({
    required this.id,
    required this.locationId,
    required this.ownerUserId,
    required this.name,
    required this.slug,
    required this.category,
    required this.isVerified,
    required this.status,
    this.description,
    this.logo,
    this.coverImage,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  final String id;
  final String locationId;
  final String ownerUserId;
  final String name;
  final String slug;
  final String category;
  final String? description;
  final String? logo;
  final String? coverImage;
  final String? phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool isVerified;
  final String status;
  final double? distanceKm;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json['id'] as String,
        locationId: json['location_id'] as String? ?? '',
        ownerUserId: json['owner_user_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        category: json['category'] as String? ?? '',
        description: readString(json['description']),
        logo: readString(json['logo']),
        coverImage: readString(json['cover_image']),
        phone: readString(json['phone']),
        address: readString(json['address']),
        latitude: readDouble(json['latitude']),
        longitude: readDouble(json['longitude']),
        isVerified: readBool(json['is_verified']),
        status: json['status'] as String? ?? 'active',
        distanceKm: readDouble(json['distance_km']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_id': locationId,
        'owner_user_id': ownerUserId,
        'name': name,
        'slug': slug,
        'category': category,
        'description': description,
        'logo': logo,
        'cover_image': coverImage,
        'phone': phone,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'is_verified': isVerified,
        'status': status,
        'distance_km': distanceKm,
      };

  Business copyWith({String? name, String? description, bool? isVerified, double? distanceKm}) => Business(
        id: id,
        locationId: locationId,
        ownerUserId: ownerUserId,
        name: name ?? this.name,
        slug: slug,
        category: category,
        description: description ?? this.description,
        logo: logo,
        coverImage: coverImage,
        phone: phone,
        address: address,
        latitude: latitude,
        longitude: longitude,
        isVerified: isVerified ?? this.isVerified,
        status: status,
        distanceKm: distanceKm ?? this.distanceKm,
      );
}
