import 'dart:convert';

import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/offline/database.dart' as offline;
import '../domain/government_service.dart';

/// Reads the offline-synced `services`/`service_categories` tables (Section:
/// offline-first plan) - `SyncEngine` keeps them fresh in the background.
class ServicesRepository {
  ServicesRepository({required ApiClient api, required offline.OfflineDatabase db})
      : _api = api,
        _db = db;

  final ApiClient _api;
  final offline.OfflineDatabase _db;

  Stream<List<GovernmentService>> watchServices() {
    return _db.select(_db.services).watch().map((rows) => rows.map(_toService).toList());
  }

  Stream<List<ServiceCategory>> watchCategories() {
    return _db.select(_db.serviceCategories).watch().map(
          (rows) => rows.map((r) => ServiceCategory(id: r.id, name: r.name, parentId: r.parentId)).toList(),
        );
  }

  Future<GovernmentService> getService(String id, {CancelToken? cancelToken}) async {
    final row = await (_db.select(_db.services)..where((s) => s.id.equals(id))).getSingleOrNull();
    if (row != null) return _toService(row);
    final json = await _api.get(ApiPaths.service(id), cancelToken: cancelToken);
    return GovernmentService.fromJson(asJsonObject(json));
  }

  GovernmentService _toService(offline.Service row) => GovernmentService(
        id: row.id,
        locationId: row.locationId,
        categoryId: row.categoryId,
        name: row.name,
        description: row.description,
        eligibility: row.eligibility,
        requiredDocuments: (jsonDecode(row.requiredDocumentsJson) as List<dynamic>).cast<String>(),
        fee: row.fee,
        officialLink: row.officialLink,
        officeName: row.officeName,
        officeContact: row.officeContact,
        status: row.status,
      );
}

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  return ServicesRepository(api: ref.watch(apiClientProvider), db: ref.watch(offline.offlineDatabaseProvider));
});
