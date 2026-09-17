import '../../../core/models/json_helpers.dart';

/// Slim projection of `PlaceResponse` for the home carousel. Kept local to the
/// home feature so it does not import from `features/explore` (Section 8.8).
class FeaturedPlace {
  const FeaturedPlace({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    this.coverImage,
  });

  final String id;
  final String name;
  final String slug;
  final String category;
  final String? coverImage;

  factory FeaturedPlace.fromJson(Map<String, dynamic> json) => FeaturedPlace(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        category: json['category'] as String? ?? 'other',
        coverImage: readString(json['cover_image']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'category': category,
        'cover_image': coverImage,
      };
}
