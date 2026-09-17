import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location.dart';
import '../offline/database.dart' as offline;

/// Location hierarchy (upazila -> union -> village). Reads the offline-synced
/// `locations` table (Section: offline-first plan) - `SyncEngine` keeps this
/// tenant's one upazila plus its unions/villages fresh in the background, so
/// every location picker in the app (the marketplace sell form, the Unions
/// tab) works with zero network.
class LocationsRepository {
  LocationsRepository({required offline.OfflineDatabase db}) : _db = db;

  final offline.OfflineDatabase _db;

  Future<List<AppLocation>> list({String? type, String? parentId, CancelToken? cancelToken}) async {
    final query = _db.select(_db.locations);
    if (type != null) query.where((l) => l.type.equals(type));
    if (parentId != null) query.where((l) => l.parentId.equals(parentId));
    final rows = await query.get();
    return rows.map((row) => AppLocation(id: row.id, type: row.type, name: row.name, parentId: row.parentId)).toList();
  }
}

final locationsRepositoryProvider = Provider<LocationsRepository>((ref) {
  return LocationsRepository(db: ref.watch(offline.offlineDatabaseProvider));
});

/// Location picker options for the sell form: this tenant's one upazila plus
/// its unions (mirrors `frontend/lib/locations.ts` `getLocationOptions`).
final sellLocationOptionsProvider = FutureProvider<List<AppLocation>>((ref) async {
  final repository = ref.watch(locationsRepositoryProvider);
  final upazilas = await repository.list(type: 'upazila');
  if (upazilas.isEmpty) return const [];
  final upazila = upazilas.first;
  final unions = await repository.list(type: 'union', parentId: upazila.id);
  return [upazila, ...unions];
});
