import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/offline/database.dart' as offline;
import '../domain/featured_place.dart';
import '../domain/recommendations.dart';

class HomeRepository {
  HomeRepository({required ApiClient api, required offline.OfflineDatabase db})
      : _api = api,
        _db = db;

  final ApiClient _api;
  final offline.OfflineDatabase _db;

  /// Reactive local read: `SyncEngine` keeps the `places` table fresh in the
  /// background (Section: offline-first plan), so this never touches the
  /// network and works with zero connectivity.
  Stream<List<FeaturedPlace>> watchFeaturedPlaces() {
    final query = _db.select(_db.places)..where((p) => p.isFeatured.equals(true));
    return query.watch().map((rows) => rows.map(_toFeaturedPlace).toList());
  }

  FeaturedPlace _toFeaturedPlace(offline.Place row) => FeaturedPlace(
        id: row.id,
        name: row.name,
        slug: row.slug,
        category: row.category,
        coverImage: row.coverImage,
      );

  /// `GET /recommendations` (Section 17 Phase 4 "For You") - mixes
  /// marketplace/exchange listings, which stay online-only per the
  /// offline-first plan, so this endpoint is not synced and simply fails
  /// when offline like any other online-only call. [locationId] scopes
  /// trending/nearby content to the tenant's upazila (backend widens from
  /// there when there isn't enough local content).
  Future<Recommendations> fetchRecommendations({String? locationId, CancelToken? cancelToken}) async {
    final json = await _api.get(
      ApiPaths.recommendations,
      query: {if (locationId != null) 'location_id': locationId},
      cancelToken: cancelToken,
    );
    return Recommendations.fromJson(asJsonObject(json));
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(api: ref.watch(apiClientProvider), db: ref.watch(offline.offlineDatabaseProvider));
});
