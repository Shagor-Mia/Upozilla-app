import '../../../core/models/json_helpers.dart';

/// `PlaceResponse` (+ `distance_km` when queried with a "near me" filter).
class Place {
  const Place({
    required this.id,
    required this.locationId,
    required this.name,
    required this.slug,
    required this.category,
    required this.isFeatured,
    required this.status,
    this.description,
    this.coverImage,
    this.gallery = const [],
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  final String id;
  final String locationId;
  final String name;
  final String slug;
  final String category;
  final String? description;
  final String? coverImage;
  final List<String> gallery;
  final double? latitude;
  final double? longitude;
  final bool isFeatured;
  final String status;
  final double? distanceKm;

  bool get hasCoordinates => latitude != null && longitude != null;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        id: json['id'] as String,
        locationId: json['location_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        category: json['category'] as String? ?? 'other',
        description: readString(json['description']),
        coverImage: readString(json['cover_image']),
        gallery: readStringList(json['gallery']),
        latitude: readDouble(json['latitude']),
        longitude: readDouble(json['longitude']),
        isFeatured: readBool(json['is_featured']),
        status: json['status'] as String? ?? 'published',
        distanceKm: readDouble(json['distance_km']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_id': locationId,
        'name': name,
        'slug': slug,
        'category': category,
        'description': description,
        'cover_image': coverImage,
        'gallery': gallery,
        'latitude': latitude,
        'longitude': longitude,
        'is_featured': isFeatured,
        'status': status,
        'distance_km': distanceKm,
      };

  Place copyWith({String? name, String? description, bool? isFeatured, double? distanceKm}) => Place(
        id: id,
        locationId: locationId,
        name: name ?? this.name,
        slug: slug,
        category: category,
        description: description ?? this.description,
        coverImage: coverImage,
        gallery: gallery,
        latitude: latitude,
        longitude: longitude,
        isFeatured: isFeatured ?? this.isFeatured,
        status: status,
        distanceKm: distanceKm ?? this.distanceKm,
      );
}
