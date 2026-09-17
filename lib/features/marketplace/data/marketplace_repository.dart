import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/models/json_helpers.dart';
import '../../../core/models/paginated.dart';
import '../domain/contact_reveal.dart';
import '../domain/exchange_listing.dart';
import '../domain/favorites.dart';
import '../domain/listing_query.dart';
import '../domain/product.dart';
import '../domain/seller_review.dart';

/// Local Bazar products + Exchange classifieds: read flows, favorites,
/// reports, contact reveal, the sell/manage-own-listings write flows, and
/// seller profiles/reviews. Listings churn quickly and are viewer-dependent
/// (`is_favorited`), so nothing here is cached.
class MarketplaceRepository {
  MarketplaceRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  // --- read: products / exchange listings -------------------------------------

  Future<Paginated<Product>> listProducts(ListingQuery query, {CancelToken? cancelToken}) async {
    final json = await _api.get(
      ApiPaths.marketplaceProducts,
      query: query.toQueryParameters(),
      cancelToken: cancelToken,
    );
    return Paginated.fromJson(asJsonObject(json), Product.fromJson);
  }

  Future<Product> getProduct(String id, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.marketplaceProduct(id), cancelToken: cancelToken);
    return Product.fromJson(asJsonObject(json));
  }

  Future<Paginated<ExchangeListing>> listExchange(ListingQuery query, {CancelToken? cancelToken}) async {
    final json = await _api.get(
      ApiPaths.exchangeListings,
      query: query.toQueryParameters(),
      cancelToken: cancelToken,
    );
    return Paginated.fromJson(asJsonObject(json), ExchangeListing.fromJson);
  }

  Future<ExchangeListing> getExchangeListing(String id, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.exchangeListing(id), cancelToken: cancelToken);
    return ExchangeListing.fromJson(asJsonObject(json));
  }

  Future<List<ListingCategory>> listCategories({CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.marketplaceCategories, cancelToken: cancelToken);
    return asJsonList(json).map(ListingCategory.fromJson).toList();
  }

  // --- favorites (both listing kinds) ------------------------------------------

  /// `PUT`/`DELETE /exchange/favorites/{listingType}/{listingId}`. Returns the
  /// server's `is_favorited` so callers can reconcile an optimistic toggle.
  Future<bool> setFavorite({
    required String listingType,
    required String listingId,
    required bool favorite,
    CancelToken? cancelToken,
  }) async {
    final json = favorite
        ? await _api.put(ApiPaths.exchangeFavorite(listingType, listingId), cancelToken: cancelToken)
        : await _api.delete(ApiPaths.exchangeFavorite(listingType, listingId), cancelToken: cancelToken);
    return readBool(asJsonObject(json)['is_favorited']);
  }

  Future<Favorites> listFavorites({CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.exchangeFavorites, cancelToken: cancelToken);
    return Favorites.fromJson(asJsonObject(json));
  }

  // --- reports (both listing kinds, fire-and-forget from the UI) ---------------

  Future<void> reportListing({
    required String listingType,
    required String listingId,
    required String reason,
    String? details,
    CancelToken? cancelToken,
  }) async {
    await _api.post(
      ApiPaths.exchangeReport(listingType, listingId),
      body: {'reason': reason, if (details != null && details.isNotEmpty) 'details': details},
      cancelToken: cancelToken,
    );
  }

  // --- contact reveal (Section 14.4: gated + rate limited) ----------------------

  Future<ContactReveal> revealExchangeContact(String id, {CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.exchangeListingContact(id), cancelToken: cancelToken);
    return ContactReveal.fromJson(asJsonObject(json));
  }

  Future<ContactReveal> revealProductContact(String id, {CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.marketplaceProductContact(id), cancelToken: cancelToken);
    return ContactReveal.fromJson(asJsonObject(json));
  }

  // --- sell / manage own listings: Local Bazar products --------------------------

  Future<Product> createProduct({
    required String categoryId,
    required String title,
    String? description,
    required double price,
    required String condition,
    required List<String> images,
    required String locationId,
    double? latitude,
    double? longitude,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.marketplaceProducts,
      // `business_id` is intentionally omitted here (v1 trim, see brief): the
      // field is nullable server-side and there is no "my businesses" endpoint
      // yet to populate a picker for it.
      body: {
        'category_id': categoryId,
        'title': title,
        if (description != null && description.isNotEmpty) 'description': description,
        'price': price,
        'condition': condition,
        'images': images,
        'location_id': locationId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      },
      cancelToken: cancelToken,
    );
    return Product.fromJson(asJsonObject(json));
  }

  Future<Product> updateProductStatus(String id, {required String status, CancelToken? cancelToken}) async {
    final json = await _api.patch(ApiPaths.marketplaceProduct(id), body: {'status': status}, cancelToken: cancelToken);
    return Product.fromJson(asJsonObject(json));
  }

  Future<void> deleteProduct(String id, {CancelToken? cancelToken}) async {
    await _api.delete(ApiPaths.marketplaceProduct(id), cancelToken: cancelToken);
  }

  Future<List<Product>> listMyProducts({CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.marketplaceProductsMine, cancelToken: cancelToken);
    return asJsonList(json).map(Product.fromJson).toList();
  }

  // --- sell / manage own listings: Exchange classifieds ---------------------------

  Future<ExchangeListing> createExchangeListing({
    required String categoryId,
    required String title,
    String? description,
    required double price,
    required bool isNegotiable,
    required String condition,
    required List<String> images,
    required String locationId,
    double? latitude,
    double? longitude,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.exchangeListings,
      body: {
        'category_id': categoryId,
        'title': title,
        if (description != null && description.isNotEmpty) 'description': description,
        'price': price,
        'is_negotiable': isNegotiable,
        'condition': condition,
        'images': images,
        'location_id': locationId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      },
      cancelToken: cancelToken,
    );
    return ExchangeListing.fromJson(asJsonObject(json));
  }

  Future<ExchangeListing> updateExchangeListingStatus(
    String id, {
    required String status,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.patch(ApiPaths.exchangeListing(id), body: {'status': status}, cancelToken: cancelToken);
    return ExchangeListing.fromJson(asJsonObject(json));
  }

  Future<void> deleteExchangeListing(String id, {CancelToken? cancelToken}) async {
    await _api.delete(ApiPaths.exchangeListing(id), cancelToken: cancelToken);
  }

  Future<List<ExchangeListing>> listMyExchangeListings({CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.exchangeListingsMine, cancelToken: cancelToken);
    return asJsonList(json).map(ExchangeListing.fromJson).toList();
  }

  // --- seller profile & reviews ---------------------------------------------------

  Future<SellerProfile> getSellerProfile(String id, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.seller(id), cancelToken: cancelToken);
    return SellerProfile.fromJson(asJsonObject(json));
  }

  Future<SellerReview> submitSellerReview({
    required String sellerId,
    required int rating,
    String? comment,
    String? listingType,
    String? listingId,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.sellerReviews(sellerId),
      body: {
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
        if (listingType != null) 'listing_type': listingType,
        if (listingId != null) 'listing_id': listingId,
      },
      cancelToken: cancelToken,
    );
    return SellerReview.fromJson(asJsonObject(json));
  }
}

final marketplaceRepositoryProvider = Provider<MarketplaceRepository>((ref) {
  return MarketplaceRepository(api: ref.watch(apiClientProvider));
});
