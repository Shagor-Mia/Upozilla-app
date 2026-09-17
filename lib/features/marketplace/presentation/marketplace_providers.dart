import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/models/paginated.dart';
import '../../../core/observability/logger.dart';
import '../data/marketplace_repository.dart';
import '../domain/exchange_listing.dart';
import '../domain/favorites.dart';
import '../domain/listing_query.dart';
import '../domain/paged_items.dart';
import '../domain/product.dart';
import '../domain/seller_review.dart';

/// Debounced search text shared by both tabs.
final listingSearchProvider = StateProvider<String>((ref) => '');

/// Current list filter derived from the search box (page is always 1 here;
/// paging is handled inside the notifiers).
final listingQueryProvider = Provider<ListingQuery>((ref) {
  final q = ref.watch(listingSearchProvider);
  return ListingQuery(q: q.isEmpty ? null : q);
});

/// Shared infinite-scroll behaviour for both listing kinds.
abstract class PagedListingNotifier<T> extends AutoDisposeFamilyAsyncNotifier<PagedItems<T>, ListingQuery> {
  Future<Paginated<T>> fetchPage(ListingQuery query, CancelToken cancelToken);

  late CancelToken _cancelToken;

  @override
  Future<PagedItems<T>> build(ListingQuery arg) async {
    _cancelToken = CancelToken();
    ref.onDispose(_cancelToken.cancel);
    final first = await fetchPage(arg.copyWith(page: 1), _cancelToken);
    return PagedItems.fromPage(first);
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    state = AsyncData(current.copyWith(isLoadingMore: true));
    try {
      final next = await fetchPage(arg.copyWith(page: current.page + 1), _cancelToken);
      state = AsyncData(current.append(next));
    } on CancelledException {
      return;
    } on AppException catch (e) {
      // Keep what is already on screen; the user can scroll again to retry.
      AppLogger.warn('load more failed', tag: 'marketplace', fields: {'reason': e.runtimeType});
      state = AsyncData(current.copyWith(isLoadingMore: false));
    }
  }
}

class ProductsNotifier extends PagedListingNotifier<Product> {
  @override
  Future<Paginated<Product>> fetchPage(ListingQuery query, CancelToken cancelToken) {
    return ref.read(marketplaceRepositoryProvider).listProducts(query, cancelToken: cancelToken);
  }
}

class ExchangeListingsNotifier extends PagedListingNotifier<ExchangeListing> {
  @override
  Future<Paginated<ExchangeListing>> fetchPage(ListingQuery query, CancelToken cancelToken) {
    return ref.read(marketplaceRepositoryProvider).listExchange(query, cancelToken: cancelToken);
  }
}

final productsProvider =
    AsyncNotifierProvider.autoDispose.family<ProductsNotifier, PagedItems<Product>, ListingQuery>(
  ProductsNotifier.new,
);

final exchangeListingsProvider = AsyncNotifierProvider.autoDispose
    .family<ExchangeListingsNotifier, PagedItems<ExchangeListing>, ListingQuery>(
  ExchangeListingsNotifier.new,
);

final productDetailProvider = FutureProvider.autoDispose.family<Product, String>((ref, id) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(marketplaceRepositoryProvider).getProduct(id, cancelToken: cancelToken);
});

final exchangeDetailProvider = FutureProvider.autoDispose.family<ExchangeListing, String>((ref, id) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(marketplaceRepositoryProvider).getExchangeListing(id, cancelToken: cancelToken);
});

/// Categories for both listing kinds share one backend list (Section 12).
final listingCategoriesProvider = FutureProvider.autoDispose<List<ListingCategory>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(marketplaceRepositoryProvider).listCategories(cancelToken: cancelToken);
});

final favoritesProvider = FutureProvider.autoDispose<Favorites>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(marketplaceRepositoryProvider).listFavorites(cancelToken: cancelToken);
});

final myProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(marketplaceRepositoryProvider).listMyProducts(cancelToken: cancelToken);
});

final myExchangeListingsProvider = FutureProvider.autoDispose<List<ExchangeListing>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(marketplaceRepositoryProvider).listMyExchangeListings(cancelToken: cancelToken);
});

final sellerProfileProvider = FutureProvider.autoDispose.family<SellerProfile, String>((ref, id) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(marketplaceRepositoryProvider).getSellerProfile(id, cancelToken: cancelToken);
});
