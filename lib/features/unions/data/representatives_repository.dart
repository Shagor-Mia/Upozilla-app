import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/offline/database.dart' as offline;
import '../domain/representative.dart';

/// Elected-official directory (chairman / women member / ward member).
/// Browsing reads the offline-synced `representatives` table (Section:
/// offline-first plan); `mine` and `update` stay online-only (user-scoped /
/// a write).
class RepresentativesRepository {
  RepresentativesRepository({required ApiClient api, required offline.OfflineDatabase db})
      : _api = api,
        _db = db;

  final ApiClient _api;
  final offline.OfflineDatabase _db;

  Future<List<Representative>> list({String? locationId, String? position, CancelToken? cancelToken}) async {
    final query = _db.select(_db.representatives);
    if (locationId != null) query.where((r) => r.locationId.equals(locationId));
    if (position != null) query.where((r) => r.position.equals(position));
    final rows = await query.get();
    return rows.map(_toRepresentative).toList();
  }

  Future<Representative> get(String id, {CancelToken? cancelToken}) async {
    final row = await (_db.select(_db.representatives)..where((r) => r.id.equals(id))).getSingleOrNull();
    if (row != null) return _toRepresentative(row);
    final json = await _api.get(ApiPaths.representative(id), cancelToken: cancelToken);
    return Representative.fromJson(asJsonObject(json));
  }

  /// User-scoped, not part of the offline directory sync - always network.
  Future<List<Representative>> listMine({CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.representativesMine, cancelToken: cancelToken);
    return asJsonList(json).map(Representative.fromJson).toList();
  }

  /// Write action - stays online-only, same as every mutation in the app.
  Future<Representative> update(
    String id, {
    String? bio,
    String? photoUrl,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.patch(
      ApiPaths.representative(id),
      body: {'bio': bio, 'photo_url': photoUrl},
      cancelToken: cancelToken,
    );
    return Representative.fromJson(asJsonObject(json));
  }

  Representative _toRepresentative(offline.Representative row) => Representative(
        id: row.id,
        userId: row.userId,
        fullName: row.fullName,
        phone: row.phone,
        locationId: row.locationId,
        locationName: row.locationName,
        position: row.position,
        bio: row.bio,
        photoUrl: row.photoUrl,
        status: row.status,
      );
}

final representativesRepositoryProvider = Provider<RepresentativesRepository>((ref) {
  return RepresentativesRepository(api: ref.watch(apiClientProvider), db: ref.watch(offline.offlineDatabaseProvider));
});
