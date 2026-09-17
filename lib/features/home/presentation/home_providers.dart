import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/locations_repository.dart';
import '../data/home_repository.dart';
import '../domain/featured_place.dart';
import '../domain/recommendations.dart';

final homeRefreshTickProvider = StateProvider<int>((ref) => 0);

/// Reads straight from the offline-synced `places` table (Section:
/// offline-first plan) - reactive, so it updates on its own whenever
/// `SyncEngine` writes fresh data; no manual refresh plumbing needed here.
final featuredPlacesProvider = StreamProvider.autoDispose<List<FeaturedPlace>>((ref) {
  return ref.watch(homeRepositoryProvider).watchFeaturedPlaces();
});

/// Scopes "For You" to the tenant's one upazila (single-tenant deployment,
/// same assumption `sellLocationOptionsProvider` makes) so the backend's
/// location-aware trending/nearby widening actually engages.
final recommendationsProvider = FutureProvider.autoDispose<Recommendations>((ref) async {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  ref.watch(homeRefreshTickProvider);
  final upazilas = await ref.watch(locationsRepositoryProvider).list(type: 'upazila');
  final locationId = upazilas.isEmpty ? null : upazilas.first.id;
  return ref
      .watch(homeRepositoryProvider)
      .fetchRecommendations(locationId: locationId, cancelToken: cancelToken);
});
