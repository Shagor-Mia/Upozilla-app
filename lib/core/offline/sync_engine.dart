import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/explore/domain/business.dart';
import '../../features/explore/domain/hospital.dart';
import '../../features/explore/domain/market.dart';
import '../../features/explore/domain/place.dart';
import '../../features/faqs/domain/faq.dart';
import '../../features/news/domain/news_article.dart';
import '../../features/services/domain/government_service.dart';
import '../../features/shops/domain/shop.dart';
import '../../features/unions/domain/representative.dart';
import '../api/api_client.dart';
import '../api/api_paths.dart';
import '../models/location.dart';
import '../observability/logger.dart';
// Drift generates a singular row-data class per table (e.g. table `Faqs` ->
// class `Faq`) which collides with this app's existing domain model classes
// of the same name - hide them since sync_engine only ever needs the
// `*Companion` (write) types from this import, never the row classes.
import 'database.dart' hide Faq, ShopCategory, Shop, Representative, NewsArticle, ServiceCategory, Place, Hospital, Market, Doctor;

/// Downloads every offline-browsable directory entity into [OfflineDatabase]
/// so the app works with zero network. The backend has no `updated_since`/
/// delta filter on any of these list endpoints, and the per-tenant dataset is
/// small (single upazila — representatives capped ~120 rows, the rest tens to
/// low hundreds), so a full re-page-and-replace per entity on every sync is
/// simple and cheap rather than trying to diff.
///
/// Marketplace/exchange, messaging and AI chat are intentionally absent here
/// — those stay online-only per the offline-first plan.
class SyncEngine {
  SyncEngine({required ApiClient api, required OfflineDatabase db})
      : _api = api,
        _db = db;

  final ApiClient _api;
  final OfflineDatabase _db;

  static const _pageSize = 60;

  /// Order matters only for [_syncDoctors], which reads hospitals already
  /// written to the DB. Each entity's failure is isolated and logged so one
  /// broken endpoint never blocks the rest — safe to call fire-and-forget.
  Future<void> syncAll() async {
    final tasks = <String, Future<void> Function()>{
      'locations': _syncLocations,
      'faqs': _syncFaqs,
      'shop_categories': _syncShopCategories,
      'shops': _syncShops,
      'representatives': _syncRepresentatives,
      'news': _syncNews,
      'service_categories': _syncServiceCategories,
      'services': _syncServices,
      'places': _syncPlaces,
      'hospitals': _syncHospitals,
      'markets': _syncMarkets,
      'businesses': _syncBusinesses,
      'doctors': _syncDoctors,
    };
    for (final entry in tasks.entries) {
      try {
        await entry.value();
        await _touchSyncMeta(entry.key);
      } on Object catch (e) {
        AppLogger.warn('offline sync failed', tag: 'offline_sync', fields: {'entity': entry.key, 'err': e.toString()});
      }
    }
  }

  Future<DateTime?> lastSyncedAt(String entity) async {
    final row = await (_db.select(_db.syncMeta)..where((t) => t.entity.equals(entity))).getSingleOrNull();
    return row?.lastSyncedAt;
  }

  /// Whether the first-launch sync has ever completed (checked against a
  /// core entity so the UI can decide whether to show a "preparing offline
  /// data" indicator).
  Future<bool> hasSyncedOnce() async => await lastSyncedAt('places') != null;

  Future<void> _touchSyncMeta(String entity) {
    return _db
        .into(_db.syncMeta)
        .insertOnConflictUpdate(SyncMetaCompanion.insert(entity: entity, lastSyncedAt: DateTime.now()));
  }

  Future<List<Map<String, dynamic>>> _fetchAllPages(String endpoint, {Map<String, Object?> query = const {}}) async {
    final items = <Map<String, dynamic>>[];
    var page = 1;
    while (true) {
      final json = await _api.get(endpoint, query: {...query, 'page': page, 'page_size': _pageSize})
          as Map<String, dynamic>;
      final pageItems = (json['items'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();
      items.addAll(pageItems);
      final total = json['total'] as int? ?? items.length;
      if (pageItems.isEmpty || items.length >= total) break;
      page++;
    }
    return items;
  }

  Future<List<Map<String, dynamic>>> _fetchList(String endpoint, {Map<String, Object?> query = const {}}) async {
    final json = await _api.get(endpoint, query: query);
    return (json as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<void> _replaceTable<T extends Table, D>(TableInfo<T, D> table, List<Insertable<D>> rows) {
    return _db.transaction(() async {
      await _db.delete(table).go();
      if (rows.isNotEmpty) {
        await _db.batch((b) => b.insertAll(table, rows, mode: InsertMode.insertOrReplace));
      }
    });
  }

  /// `/locations` with no filter returns every division/district/upazila/
  /// union in the country (see `locations_repository.dart` doc comment) -
  /// far more than this single-upazila app ever needs and too large to sync
  /// wholesale. Every current use of location data (`upazilaProvider`,
  /// `unionsProvider`, `villagesProvider`, the sell-form location picker)
  /// only ever needs this tenant's one upazila plus its unions and their
  /// villages, so that's the exact subtree fetched here.
  Future<void> _syncLocations() async {
    final upazilas = await _fetchList(ApiPaths.locations, query: {'type': 'upazila'});
    final rows = <Map<String, dynamic>>[...upazilas];
    if (upazilas.isNotEmpty) {
      final upazilaId = upazilas.first['id'] as String;
      final unions = await _fetchList(ApiPaths.locations, query: {'type': 'union', 'parent_id': upazilaId});
      rows.addAll(unions);
      for (final union in unions) {
        final unionId = union['id'] as String;
        final villages = await _fetchList(ApiPaths.locations, query: {'type': 'village', 'parent_id': unionId});
        rows.addAll(villages);
      }
    }
    final companions = rows.map(AppLocation.fromJson).map(
          (l) => LocationsCompanion.insert(id: l.id, type: l.type, name: l.name, parentId: Value(l.parentId)),
        );
    await _replaceTable(_db.locations, companions.toList());
  }

  Future<void> _syncFaqs() async {
    final json = await _fetchList(ApiPaths.faqs);
    final rows = json.map(Faq.fromJson).map(
          (f) => FaqsCompanion.insert(id: f.id, question: f.question, answer: f.answer, status: Value(f.status)),
        );
    await _replaceTable(_db.faqs, rows.toList());
  }

  Future<void> _syncShopCategories() async {
    final json = await _fetchList(ApiPaths.shopCategories);
    final rows = json.map(ShopCategory.fromJson).map(
          (c) => ShopCategoriesCompanion.insert(
            id: c.id,
            name: c.name,
            slug: c.slug,
            icon: Value(c.icon),
            sortOrder: Value(c.sortOrder),
          ),
        );
    await _replaceTable(_db.shopCategories, rows.toList());
  }

  Future<void> _syncShops() async {
    final json = await _fetchAllPages(ApiPaths.shops);
    final rows = json.map(Shop.fromJson).map(
          (s) => ShopsCompanion.insert(
            id: s.id,
            marketId: s.marketId,
            marketName: s.marketName,
            categoryId: s.categoryId,
            categoryName: s.categoryName,
            name: s.name,
            description: Value(s.description),
            contactPhone: Value(s.contactPhone),
            imagesJson: Value(jsonEncode(s.images)),
            isFeatured: Value(s.isFeatured),
            status: Value(s.status),
            moderationStatus: Value(s.moderationStatus),
            createdAt: Value(s.createdAt),
            sellerId: s.seller.id,
            sellerFullName: s.seller.fullName,
            sellerPhoneVerified: Value(s.seller.phoneVerified),
          ),
        );
    await _replaceTable(_db.shops, rows.toList());
  }

  Future<void> _syncRepresentatives() async {
    final json = await _fetchAllPages(ApiPaths.representatives);
    final rows = json.map(Representative.fromJson).map(
          (r) => RepresentativesCompanion.insert(
            id: r.id,
            userId: r.userId,
            fullName: r.fullName,
            phone: Value(r.phone),
            locationId: r.locationId,
            locationName: r.locationName,
            position: Value(r.position),
            bio: Value(r.bio),
            photoUrl: Value(r.photoUrl),
            status: Value(r.status),
          ),
        );
    await _replaceTable(_db.representatives, rows.toList());
  }

  /// `/news` list rows omit `body`/`original_url` (detail-only fields), so
  /// unlike the other entities this needs a second per-article fetch to make
  /// full articles readable offline. The dataset is small (editorially
  /// curated), so the N+1 cost is a one-time/background expense.
  Future<void> _syncNews() async {
    final list = await _fetchAllPages(ApiPaths.news);
    final articles = <NewsArticle>[];
    for (final summary in list) {
      final slug = summary['slug'] as String?;
      if (slug == null) continue;
      try {
        final detail = await _api.get(ApiPaths.newsArticle(slug)) as Map<String, dynamic>;
        articles.add(NewsArticle.fromJson(detail));
      } on Object catch (_) {
        articles.add(NewsArticle.fromJson(summary));
      }
    }
    final rows = articles.map(
      (a) => NewsArticlesCompanion.insert(
        id: a.id,
        sourceId: a.sourceId,
        locationId: Value(a.locationId),
        category: Value(a.category),
        title: a.title,
        slug: a.slug,
        summary: Value(a.summary),
        image: Value(a.image),
        publishedAt: Value(a.publishedAt),
        status: Value(a.status),
        body: Value(a.body),
        originalUrl: Value(a.originalUrl),
      ),
    );
    await _replaceTable(_db.newsArticles, rows.toList());
  }

  Future<void> _syncServiceCategories() async {
    final json = await _fetchList(ApiPaths.serviceCategories);
    final rows = json.map(ServiceCategory.fromJson).map(
          (c) => ServiceCategoriesCompanion.insert(id: c.id, name: c.name, parentId: Value(c.parentId)),
        );
    await _replaceTable(_db.serviceCategories, rows.toList());
  }

  Future<void> _syncServices() async {
    final json = await _fetchAllPages(ApiPaths.services);
    final rows = json.map(GovernmentService.fromJson).map(
          (s) => ServicesCompanion.insert(
            id: s.id,
            locationId: s.locationId,
            categoryId: s.categoryId,
            name: s.name,
            description: Value(s.description),
            eligibility: Value(s.eligibility),
            requiredDocumentsJson: Value(jsonEncode(s.requiredDocuments)),
            fee: Value(s.fee),
            officialLink: Value(s.officialLink),
            officeName: Value(s.officeName),
            officeContact: Value(s.officeContact),
            status: Value(s.status),
          ),
        );
    await _replaceTable(_db.services, rows.toList());
  }

  Future<void> _syncPlaces() async {
    final json = await _fetchAllPages(ApiPaths.places);
    final rows = json.map(Place.fromJson).map(
          (p) => PlacesCompanion.insert(
            id: p.id,
            locationId: p.locationId,
            name: p.name,
            slug: p.slug,
            category: p.category,
            description: Value(p.description),
            coverImage: Value(p.coverImage),
            galleryJson: Value(jsonEncode(p.gallery)),
            latitude: Value(p.latitude),
            longitude: Value(p.longitude),
            isFeatured: Value(p.isFeatured),
            status: Value(p.status),
          ),
        );
    await _replaceTable(_db.places, rows.toList());
  }

  Future<void> _syncHospitals() async {
    final json = await _fetchAllPages(ApiPaths.hospitals);
    final rows = json.map(Hospital.fromJson).map(
          (h) => HospitalsCompanion.insert(
            id: h.id,
            locationId: h.locationId,
            name: h.name,
            type: Value(h.type),
            address: Value(h.address),
            contact: Value(h.contact),
            latitude: Value(h.latitude),
            longitude: Value(h.longitude),
          ),
        );
    await _replaceTable(_db.hospitals, rows.toList());
  }

  Future<void> _syncMarkets() async {
    final json = await _fetchAllPages(ApiPaths.markets);
    final rows = json.map(Market.fromJson).map(
          (m) => MarketsCompanion.insert(
            id: m.id,
            locationId: m.locationId,
            name: m.name,
            marketDaysJson: Value(jsonEncode(m.marketDays)),
            startTime: Value(m.startTime),
            endTime: Value(m.endTime),
            description: Value(m.description),
            type: Value(m.type),
            latitude: Value(m.latitude),
            longitude: Value(m.longitude),
          ),
        );
    await _replaceTable(_db.markets, rows.toList());
  }

  /// `/businesses` returns a plain array, not the `{items, total}` envelope
  /// the other directory endpoints use (see explore_repository.dart), so this
  /// uses `_fetchList` rather than `_fetchAllPages`.
  Future<void> _syncBusinesses() async {
    final json = await _fetchList(ApiPaths.businesses);
    final rows = json.map(Business.fromJson).map(
          (b) => BusinessesCompanion.insert(
            id: b.id,
            locationId: b.locationId,
            ownerUserId: b.ownerUserId,
            name: b.name,
            slug: b.slug,
            category: b.category,
            description: Value(b.description),
            logo: Value(b.logo),
            coverImage: Value(b.coverImage),
            phone: Value(b.phone),
            address: Value(b.address),
            latitude: Value(b.latitude),
            longitude: Value(b.longitude),
            isVerified: Value(b.isVerified),
            status: Value(b.status),
          ),
        );
    await _replaceTable(_db.businesses, rows.toList());
  }

  /// Depends on [_syncHospitals] having already written the hospitals table —
  /// there is no top-level `/doctors` list, only `/hospitals/:id/doctors`.
  Future<void> _syncDoctors() async {
    final hospitalRows = await _db.select(_db.hospitals).get();
    final companions = <DoctorsCompanion>[];
    for (final hospital in hospitalRows) {
      final json = await _fetchList(ApiPaths.hospitalDoctors(hospital.id));
      companions.addAll(
        json.map(Doctor.fromJson).map(
              (d) => DoctorsCompanion.insert(
                id: d.id,
                hospitalId: d.hospitalId,
                name: d.name,
                specialty: Value(d.specialty),
                chamberDaysJson: Value(jsonEncode(d.chamberDays)),
                chamberHours: Value(d.chamberHours),
                contact: Value(d.contact),
              ),
            ),
      );
    }
    await _replaceTable(_db.doctors, companions);
  }
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(api: ref.watch(apiClientProvider), db: ref.watch(offlineDatabaseProvider));
});
