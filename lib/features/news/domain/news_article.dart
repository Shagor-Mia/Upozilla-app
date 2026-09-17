import '../../../core/models/json_helpers.dart';

/// `NewsArticleResponse` / `NewsArticleDetailResponse` — `body` and
/// `originalUrl` are only present on the detail endpoint.
class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.sourceId,
    required this.title,
    required this.slug,
    required this.status,
    this.locationId,
    this.category,
    this.summary,
    this.image,
    this.publishedAt,
    this.body,
    this.originalUrl,
  });

  final String id;
  final String sourceId;
  final String? locationId;
  final String? category;
  final String title;
  final String slug;
  final String? summary;
  final String? image;
  final DateTime? publishedAt;
  final String status;
  final String? body;
  final String? originalUrl;

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        id: json['id'] as String,
        sourceId: json['source_id'] as String? ?? '',
        locationId: readString(json['location_id']),
        category: readString(json['category']),
        title: json['title'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        summary: readString(json['summary']),
        image: readString(json['image']),
        publishedAt: readDateTime(json['published_at']),
        status: json['status'] as String? ?? 'published',
        body: readString(json['body']),
        originalUrl: readString(json['original_url']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'source_id': sourceId,
        'location_id': locationId,
        'category': category,
        'title': title,
        'slug': slug,
        'summary': summary,
        'image': image,
        'published_at': publishedAt?.toIso8601String(),
        'status': status,
        'body': body,
        'original_url': originalUrl,
      };

  NewsArticle copyWith({String? body, String? originalUrl}) => NewsArticle(
        id: id,
        sourceId: sourceId,
        locationId: locationId,
        category: category,
        title: title,
        slug: slug,
        summary: summary,
        image: image,
        publishedAt: publishedAt,
        status: status,
        body: body ?? this.body,
        originalUrl: originalUrl ?? this.originalUrl,
      );
}
