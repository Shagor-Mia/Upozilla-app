import 'dart:convert';

import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/offline/database.dart' as offline;
import '../domain/shop.dart';

/// Shops (inside markets): self-submit + moderation queue, same shape as
/// marketplace's product/exchange listings. Browsing reads the offline-synced
/// `shops`/`shop_categories` tables (Section: offline-first plan); `mine` and
/// `createShop` stay online-only (user-scoped / a write).
class ShopsRepository {
  ShopsRepository({required ApiClient api, required offline.OfflineDatabase db})
      : _api = api,
        _db = db;

  final ApiClient _api;
  final offline.OfflineDatabase _db;

  Future<List<ShopCategory>> listCategories({CancelToken? cancelToken}) async {
    final rows = await _db.select(_db.shopCategories).get();
    return rows.map((r) => ShopCategory(id: r.id, name: r.name, slug: r.slug, icon: r.icon, sortOrder: r.sortOrder)).toList();
  }

  Future<List<Shop>> listShops({
    String? marketId,
    String? categoryId,
    bool featuredOnly = false,
    CancelToken? cancelToken,
  }) async {
    final query = _db.select(_db.shops);
    if (marketId != null) query.where((s) => s.marketId.equals(marketId));
    if (categoryId != null) query.where((s) => s.categoryId.equals(categoryId));
    if (featuredOnly) query.where((s) => s.isFeatured.equals(true));
    final rows = await query.get();
    return rows.map(_toShop).toList();
  }

  Future<Shop> getShop(String id, {CancelToken? cancelToken}) async {
    final row = await (_db.select(_db.shops)..where((s) => s.id.equals(id))).getSingleOrNull();
    if (row != null) return _toShop(row);
    final json = await _api.get(ApiPaths.shop(id), cancelToken: cancelToken);
    return Shop.fromJson(asJsonObject(json));
  }

  /// User-scoped, not part of the offline directory sync - always network.
  Future<List<Shop>> listMyShops({CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.shopsMine, cancelToken: cancelToken);
    return asJsonList(json).map(Shop.fromJson).toList();
  }

  /// Write action - stays online-only, same as every mutation in the app.
  Future<Shop> createShop({
    required String marketId,
    required String categoryId,
    required String name,
    String? description,
    String? contactPhone,
    required List<String> images,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.shops,
      body: {
        'market_id': marketId,
        'category_id': categoryId,
        'name': name,
        if (description != null && description.isNotEmpty) 'description': description,
        if (contactPhone != null && contactPhone.isNotEmpty) 'contact_phone': contactPhone,
        'images': images,
      },
      cancelToken: cancelToken,
    );
    return Shop.fromJson(asJsonObject(json));
  }

  Shop _toShop(offline.Shop row) => Shop(
        id: row.id,
        marketId: row.marketId,
        marketName: row.marketName,
        categoryId: row.categoryId,
        categoryName: row.categoryName,
        name: row.name,
        description: row.description,
        contactPhone: row.contactPhone,
        images: (jsonDecode(row.imagesJson) as List<dynamic>).cast<String>(),
        isFeatured: row.isFeatured,
        status: row.status,
        moderationStatus: row.moderationStatus,
        createdAt: row.createdAt,
        seller: ShopSeller(id: row.sellerId, fullName: row.sellerFullName, phoneVerified: row.sellerPhoneVerified),
      );
}

final shopsRepositoryProvider = Provider<ShopsRepository>((ref) {
  return ShopsRepository(api: ref.watch(apiClientProvider), db: ref.watch(offline.offlineDatabaseProvider));
});
