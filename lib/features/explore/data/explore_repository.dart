import 'dart:convert';

import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/models/geo.dart';
import '../../../core/offline/database.dart' as offline;
import '../domain/business.dart';
import '../domain/hospital.dart';
import '../domain/market.dart';
import '../domain/place.dart';

/// Directory content: places, hospitals (+doctors), weekly markets,
/// businesses. All reads come from the offline-synced local tables (Section:
/// offline-first plan) - `SyncEngine` keeps them fresh in the background, so
/// browsing (including "near me") works with zero network. Detail lookups
/// fall back to network only when a row is missing locally (e.g. a deep link
/// to content added after the last sync).
class ExploreRepository {
  ExploreRepository({required ApiClient api, required offline.OfflineDatabase db})
      : _api = api,
        _db = db;

  final ApiClient _api;
  final offline.OfflineDatabase _db;

  Stream<List<Place>> watchPlaces({NearMeQuery? near}) {
    return _db.select(_db.places).watch().map((rows) {
      final items = rows.map(_toPlace).toList();
      if (near == null) return items;
      return _applyNearMe<Place>(
        items: items,
        near: near,
        latOf: (p) => p.latitude,
        lngOf: (p) => p.longitude,
        withDistance: (p, d) => p.copyWith(distanceKm: d),
      );
    });
  }

  Future<Place> getPlace(String slug, {CancelToken? cancelToken}) async {
    final row = await (_db.select(_db.places)..where((p) => p.slug.equals(slug))).getSingleOrNull();
    if (row != null) return _toPlace(row);
    final json = await _api.get(ApiPaths.place(slug), cancelToken: cancelToken);
    return Place.fromJson(asJsonObject(json));
  }

  Future<List<Place>> listPlacesByLocation(String locationId, {CancelToken? cancelToken}) async {
    final rows = await (_db.select(_db.places)..where((p) => p.locationId.equals(locationId))).get();
    return rows.map(_toPlace).toList();
  }

  Stream<List<Hospital>> watchHospitals({NearMeQuery? near}) {
    return _db.select(_db.hospitals).watch().map((rows) {
      final items = rows.map(_toHospital).toList();
      if (near == null) return items;
      return _applyNearMe<Hospital>(
        items: items,
        near: near,
        latOf: (h) => h.latitude,
        lngOf: (h) => h.longitude,
        withDistance: (h, d) => h.copyWith(distanceKm: d),
      );
    });
  }

  Future<Hospital> getHospital(String id, {CancelToken? cancelToken}) async {
    final row = await (_db.select(_db.hospitals)..where((h) => h.id.equals(id))).getSingleOrNull();
    if (row != null) return _toHospital(row);
    final json = await _api.get(ApiPaths.hospital(id), cancelToken: cancelToken);
    return Hospital.fromJson(asJsonObject(json));
  }

  Future<List<Doctor>> getDoctors(String hospitalId, {CancelToken? cancelToken}) async {
    final rows = await (_db.select(_db.doctors)..where((d) => d.hospitalId.equals(hospitalId))).get();
    return rows.map(_toDoctor).toList();
  }

  Stream<List<Market>> watchMarkets({NearMeQuery? near}) {
    return _db.select(_db.markets).watch().map((rows) {
      final items = rows.map(_toMarket).toList();
      if (near == null) return items;
      return _applyNearMe<Market>(
        items: items,
        near: near,
        latOf: (m) => m.latitude,
        lngOf: (m) => m.longitude,
        withDistance: (m, d) => m.copyWith(distanceKm: d),
      );
    });
  }

  Future<Market> getMarket(String id, {CancelToken? cancelToken}) async {
    final row = await (_db.select(_db.markets)..where((m) => m.id.equals(id))).getSingleOrNull();
    if (row != null) return _toMarket(row);
    final json = await _api.get(ApiPaths.market(id), cancelToken: cancelToken);
    return Market.fromJson(asJsonObject(json));
  }

  Stream<List<Business>> watchBusinesses({NearMeQuery? near}) {
    return _db.select(_db.businesses).watch().map((rows) {
      final items = rows.map(_toBusiness).toList();
      if (near == null) return items;
      return _applyNearMe<Business>(
        items: items,
        near: near,
        latOf: (b) => b.latitude,
        lngOf: (b) => b.longitude,
        withDistance: (b, d) => b.copyWith(distanceKm: d),
      );
    });
  }

  Future<Business> getBusiness(String slug, {CancelToken? cancelToken}) async {
    final row = await (_db.select(_db.businesses)..where((b) => b.slug.equals(slug))).getSingleOrNull();
    if (row != null) return _toBusiness(row);
    final json = await _api.get(ApiPaths.business(slug), cancelToken: cancelToken);
    return Business.fromJson(asJsonObject(json));
  }

  /// Filters to rows with coordinates within [NearMeQuery.radiusKm] and sorts
  /// nearest-first, computing distance locally via [haversineKm] instead of
  /// the backend's `lat/lng/radius_km` query (Section: offline-first plan) -
  /// this is what makes "near me" work with zero network.
  List<T> _applyNearMe<T>({
    required List<T> items,
    required NearMeQuery near,
    required double? Function(T) latOf,
    required double? Function(T) lngOf,
    required T Function(T item, double distanceKm) withDistance,
  }) {
    final withDistanceEntries = <MapEntry<T, double>>[];
    for (final item in items) {
      final lat = latOf(item);
      final lng = lngOf(item);
      if (lat == null || lng == null) continue;
      final distance = haversineKm(near.center, GeoPoint(latitude: lat, longitude: lng));
      if (distance <= near.radiusKm) withDistanceEntries.add(MapEntry(item, distance));
    }
    withDistanceEntries.sort((a, b) => a.value.compareTo(b.value));
    return withDistanceEntries.map((e) => withDistance(e.key, e.value)).toList();
  }

  Place _toPlace(offline.Place row) => Place(
        id: row.id,
        locationId: row.locationId,
        name: row.name,
        slug: row.slug,
        category: row.category,
        description: row.description,
        coverImage: row.coverImage,
        gallery: _decodeStringList(row.galleryJson),
        latitude: row.latitude,
        longitude: row.longitude,
        isFeatured: row.isFeatured,
        status: row.status,
      );

  Hospital _toHospital(offline.Hospital row) => Hospital(
        id: row.id,
        locationId: row.locationId,
        name: row.name,
        type: row.type,
        address: row.address,
        contact: row.contact,
        latitude: row.latitude,
        longitude: row.longitude,
      );

  Doctor _toDoctor(offline.Doctor row) => Doctor(
        id: row.id,
        hospitalId: row.hospitalId,
        name: row.name,
        specialty: row.specialty,
        chamberDays: _decodeStringList(row.chamberDaysJson),
        chamberHours: row.chamberHours,
        contact: row.contact,
      );

  Market _toMarket(offline.Market row) => Market(
        id: row.id,
        locationId: row.locationId,
        name: row.name,
        marketDays: _decodeStringList(row.marketDaysJson),
        startTime: row.startTime,
        endTime: row.endTime,
        description: row.description,
        type: row.type,
        latitude: row.latitude,
        longitude: row.longitude,
      );

  // Drift can't cleanly singularize "Businesses" -> "Business" (it would
  // collide with this file's domain `Business` class anyway), so the
  // generated row type here is `BusinessesData` instead of `Business`.
  Business _toBusiness(offline.BusinessesData row) => Business(
        id: row.id,
        locationId: row.locationId,
        ownerUserId: row.ownerUserId,
        name: row.name,
        slug: row.slug,
        category: row.category,
        description: row.description,
        logo: row.logo,
        coverImage: row.coverImage,
        phone: row.phone,
        address: row.address,
        latitude: row.latitude,
        longitude: row.longitude,
        isVerified: row.isVerified,
        status: row.status,
      );

  List<String> _decodeStringList(String json) => (jsonDecode(json) as List<dynamic>).cast<String>();
}

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  return ExploreRepository(api: ref.watch(apiClientProvider), db: ref.watch(offline.offlineDatabaseProvider));
});
