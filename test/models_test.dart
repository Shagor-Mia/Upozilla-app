import 'package:flutter_test/flutter_test.dart';
import 'package:upazila_app/core/auth/app_user.dart';
import 'package:upazila_app/core/models/paginated.dart';
import 'package:upazila_app/features/explore/domain/hospital.dart';
import 'package:upazila_app/features/explore/domain/market.dart';
import 'package:upazila_app/features/explore/domain/place.dart';
import 'package:upazila_app/features/marketplace/domain/exchange_listing.dart';
import 'package:upazila_app/features/marketplace/domain/listing_query.dart';
import 'package:upazila_app/features/marketplace/domain/product.dart';
import 'package:upazila_app/features/news/domain/news_article.dart';
import 'package:upazila_app/features/profile/domain/app_meta.dart';

const _seller = {
  'id': 'u-1',
  'full_name': 'Rahim',
  'phone_masked': '+88017****678',
  'phone_verified': true,
  'member_since': '2025-01-02T03:04:05Z',
  'trust_score': 7,
  'avg_rating': 4.5,
  'review_count': 3,
};

void main() {
  test('Place round-trips and reads distance_km', () {
    final json = {
      'id': 'p-1',
      'location_id': 'l-1',
      'name': 'Shalbon Bihar',
      'slug': 'shalbon-bihar',
      'category': 'historical',
      'description': null,
      'cover_image': 'https://cdn/x.jpg',
      'gallery': ['https://cdn/a.jpg'],
      'latitude': 23.4,
      'longitude': 91.1,
      'is_featured': true,
      'status': 'published',
      'distance_km': 2.75,
    };
    final place = Place.fromJson(json);
    expect(place.category, 'historical');
    expect(place.distanceKm, 2.75);
    expect(place.hasCoordinates, isTrue);
    expect(Place.fromJson(place.toJson()).toJson(), json);
    expect(place.copyWith(name: 'X').name, 'X');
  });

  test('Place tolerates null gallery and integer coordinates', () {
    final place = Place.fromJson({
      'id': 'p-2',
      'location_id': 'l-1',
      'name': 'Park',
      'slug': 'park',
      'category': 'park',
      'gallery': null,
      'latitude': 23,
      'longitude': 91,
      'is_featured': false,
      'status': 'published',
    });
    expect(place.gallery, isEmpty);
    expect(place.latitude, 23.0);
    expect(place.distanceKm, isNull);
  });

  test('Hospital and Doctor parse', () {
    final hospital = Hospital.fromJson({
      'id': 'h-1',
      'location_id': 'l-1',
      'name': 'Sadar Hospital',
      'type': 'govt',
      'address': 'Main road',
      'contact': '+8801700000000',
      'latitude': null,
      'longitude': null,
    });
    expect(hospital.type, 'govt');
    expect(hospital.distanceKm, isNull);

    final doctor = Doctor.fromJson({
      'id': 'd-1',
      'hospital_id': 'h-1',
      'name': 'Dr. Karim',
      'specialty': 'Medicine',
      'chamber_days': ['sat', 'mon'],
      'chamber_hours': '5pm-9pm',
      'contact': null,
    });
    expect(doctor.chamberDays, ['sat', 'mon']);
    expect(Doctor.fromJson(doctor.toJson()).name, 'Dr. Karim');
  });

  test('Market keeps time strings verbatim', () {
    final market = Market.fromJson({
      'id': 'm-1',
      'location_id': 'l-1',
      'name': 'Friday Haat',
      'market_day': ['friday'],
      'start_time': '07:00:00',
      'end_time': '13:30:00',
      'type': 'cattle',
      'latitude': 23.1,
      'longitude': 91.2,
      'distance_km': 0.4,
    });
    expect(market.startTime, '07:00:00');
    expect(market.marketDays, ['friday']);
    expect(Market.fromJson(market.toJson()).endTime, '13:30:00');
  });

  test('Product parses nested seller and defaults', () {
    final product = Product.fromJson({
      'id': 'prod-1',
      'business_id': null,
      'business_name': null,
      'business_slug': null,
      'seller_user_id': 'u-1',
      'category_id': 'c-1',
      'category_name': 'Electronics',
      'title': 'Phone',
      'description': 'Like new',
      'price': 12000,
      'currency': 'BDT',
      'condition': 'used',
      'images': ['https://cdn/1.jpg'],
      'location_id': 'l-1',
      'location_name': 'Comilla Sadar',
      'latitude': null,
      'longitude': null,
      'status': 'active',
      'moderation_status': 'approved',
      'created_at': '2025-05-01T10:00:00Z',
      'updated_at': '2025-05-01T10:00:00Z',
      'seller': _seller,
    });
    expect(product.listingType, 'marketplace');
    expect(product.price, 12000.0);
    expect(product.coverImage, 'https://cdn/1.jpg');
    expect(product.seller.fullName, 'Rahim');
    expect(product.seller.memberSince, DateTime.utc(2025, 1, 2, 3, 4, 5));
    expect(product.isFavorited, isFalse);
    expect(Product.fromJson(product.toJson()).seller.trustScore, 7);
  });

  test('ExchangeListing parses negotiable flag and expiry', () {
    final listing = ExchangeListing.fromJson({
      'id': 'ex-1',
      'listing_type': 'exchange',
      'seller_user_id': 'u-1',
      'category_id': 'c-2',
      'category_name': 'Furniture',
      'title': 'Table',
      'description': null,
      'price': 1500.5,
      'currency': 'BDT',
      'is_negotiable': true,
      'condition': 'used',
      'images': [],
      'location_id': 'l-1',
      'location_name': 'Comilla Sadar',
      'latitude': 23.4,
      'longitude': 91.1,
      'status': 'active',
      'moderation_status': 'approved',
      'expires_at': '2025-06-01T00:00:00Z',
      'created_at': '2025-05-01T10:00:00Z',
      'updated_at': '2025-05-01T10:00:00Z',
      'seller': _seller,
      'is_favorited': true,
      'favorites_count': 2,
    });
    expect(listing.isNegotiable, isTrue);
    expect(listing.coverImage, isNull);
    expect(listing.expiresAt, DateTime.utc(2025, 6));
    expect(listing.copyWith(isFavorited: false).isFavorited, isFalse);
    expect(ExchangeListing.fromJson(listing.toJson()).favoritesCount, 2);
  });

  test('Paginated envelope', () {
    final page = Paginated<String>.fromJson(
      {
        'items': [
          {'v': 'a'},
          {'v': 'b'},
        ],
        'total': 50,
        'page': 2,
        'page_size': 24,
      },
      (json) => json['v'] as String,
    );
    expect(page.items, ['a', 'b']);
    expect(page.hasMore, isTrue);
    expect(const Paginated<int>(items: [], total: 0, page: 1, pageSize: 24).hasMore, isFalse);
  });

  test('ListingQuery is value-equal and drops empty params', () {
    const a = ListingQuery(q: 'phone', page: 2);
    const b = ListingQuery(q: 'phone', page: 2);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a.copyWith(page: 3), isNot(b));
    expect(const ListingQuery(q: '  ').toQueryParameters()['q'], isNull);
    expect(const ListingQuery().toQueryParameters()['sort'], 'newest');
  });

  test('NewsArticle list vs detail shapes', () {
    final summary = NewsArticle.fromJson({
      'id': 'n-1',
      'source_id': 's-1',
      'location_id': null,
      'category': 'local',
      'title': 'Headline',
      'slug': 'headline',
      'summary': 'Short',
      'image': null,
      'published_at': '2025-05-01T10:00:00+06:00',
      'status': 'published',
    });
    expect(summary.body, isNull);
    expect(summary.publishedAt, isNotNull);
    final detail = NewsArticle.fromJson({...summary.toJson(), 'body': 'Long text', 'original_url': 'https://x.y/z'});
    expect(detail.body, 'Long text');
    expect(detail.originalUrl, 'https://x.y/z');
  });

  test('AppUser parses roles and verification', () {
    final user = AppUser.fromJson({
      'id': 'u-1',
      'full_name': 'Rahim',
      'email': null,
      'phone': '+8801712345678',
      'role': 'user',
      'roles': ['user', 'seller'],
      'status': 'active',
      'phone_verified': true,
      'oauth_provider': null,
      'created_at': '2025-01-01T00:00:00Z',
    });
    expect(user.hasRole('seller'), isTrue);
    expect(user.phoneVerified, isTrue);
    expect(user.copyWith(phoneVerified: false).phoneVerified, isFalse);
    expect(AppUser.fromJson(user.toJson()).roles, ['user', 'seller']);
  });

  test('AppMeta defaults when fields are missing', () {
    final meta = AppMeta.fromJson({'api_version': 'v1'});
    expect(meta.minSupportedAppVersion, '0.0.0');
    expect(AppMeta.fromJson(meta.toJson()).apiVersion, 'v1');
  });
}
