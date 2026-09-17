import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../explore/data/explore_repository.dart';
import '../../explore/domain/market.dart';
import '../data/shops_repository.dart';
import '../domain/shop.dart';

CancelToken _cancelOnDispose(Ref<Object?> ref) {
  final token = CancelToken();
  ref.onDispose(token.cancel);
  return token;
}

final shopCategoriesProvider = FutureProvider.autoDispose<List<ShopCategory>>((ref) {
  return ref.watch(shopsRepositoryProvider).listCategories(cancelToken: _cancelOnDispose(ref));
});

/// One-shot list of a market's shops, read from the offline-synced `shops`
/// table (mirrors `frontend/app/(public)/markets/[id]/page.tsx`).
final marketShopsProvider = FutureProvider.autoDispose.family<List<Shop>, String>((ref, marketId) {
  return ref.watch(shopsRepositoryProvider).listShops(marketId: marketId, cancelToken: _cancelOnDispose(ref));
});

final shopDetailProvider = FutureProvider.autoDispose.family<Shop, String>((ref, id) {
  return ref.watch(shopsRepositoryProvider).getShop(id, cancelToken: _cancelOnDispose(ref));
});

final myShopsProvider = FutureProvider.autoDispose<List<Shop>>((ref) {
  return ref.watch(shopsRepositoryProvider).listMyShops(cancelToken: _cancelOnDispose(ref));
});

/// Market picker for the sell-shop form. `watchMarkets` is now a reactive,
/// never-completing local stream over the offline-synced table, so this
/// takes `.first` (the current synced value) rather than `.last`.
final marketOptionsProvider = FutureProvider.autoDispose<List<Market>>((ref) async {
  return ref.watch(exploreRepositoryProvider).watchMarkets().first;
});
