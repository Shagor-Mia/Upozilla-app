import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/location/location_service.dart';
import '../../../core/models/geo.dart';
import '../data/explore_repository.dart';
import '../domain/business.dart';
import '../domain/hospital.dart';
import '../domain/market.dart';
import '../domain/place.dart';

/// Explore tabs in display order; also used for the `?tab=` deep-link param.
enum ExploreTab {
  places,
  hospitals,
  markets,
  businesses;

  static ExploreTab fromName(String? name) =>
      ExploreTab.values.firstWhere((t) => t.name == name, orElse: () => ExploreTab.places);
}

/// "Near me" toggle (user intent).
final nearMeEnabledProvider = StateProvider<bool>((ref) => false);

final nearMeRadiusKmProvider = StateProvider<double>((ref) => NearMeQuery.defaultRadiusKm);

/// Triggers a manual `SyncEngine.syncAll()` on pull-to-refresh; the list
/// providers below no longer need to react to this directly since they read
/// the offline-synced tables reactively and update on their own once new
/// data lands.
final exploreRefreshTickProvider = StateProvider<int>((ref) => 0);

/// Resolves the toggle into a concrete query (null = plain list). Errors here
/// are [LocationException]s and surface in every tab through the list providers.
final nearMeQueryProvider = FutureProvider<NearMeQuery?>((ref) async {
  if (!ref.watch(nearMeEnabledProvider)) return null;
  final radius = ref.watch(nearMeRadiusKmProvider);
  final position = await ref.watch(locationServiceProvider).currentPosition();
  return NearMeQuery(center: position, radiusKm: radius);
});

CancelToken _cancelOnDispose(Ref<Object?> ref) {
  final token = CancelToken();
  ref.onDispose(token.cancel);
  return token;
}

// Every `ref.watch` happens before the first `await` so dependencies are
// registered synchronously; only the location lookup is awaited. Reads come
// from the offline-synced local tables (Section: offline-first plan), so
// "near me" is now computed locally too and works with zero network.

final placesProvider = StreamProvider.autoDispose<List<Place>>((ref) async* {
  final repository = ref.watch(exploreRepositoryProvider);
  final near = await ref.watch(nearMeQueryProvider.future);
  yield* repository.watchPlaces(near: near);
});

final hospitalsProvider = StreamProvider.autoDispose<List<Hospital>>((ref) async* {
  final repository = ref.watch(exploreRepositoryProvider);
  final near = await ref.watch(nearMeQueryProvider.future);
  yield* repository.watchHospitals(near: near);
});

final marketsProvider = StreamProvider.autoDispose<List<Market>>((ref) async* {
  final repository = ref.watch(exploreRepositoryProvider);
  final near = await ref.watch(nearMeQueryProvider.future);
  yield* repository.watchMarkets(near: near);
});

final businessesProvider = StreamProvider.autoDispose<List<Business>>((ref) async* {
  final repository = ref.watch(exploreRepositoryProvider);
  final near = await ref.watch(nearMeQueryProvider.future);
  yield* repository.watchBusinesses(near: near);
});

final placeDetailProvider = FutureProvider.autoDispose.family<Place, String>((ref, slug) {
  return ref.watch(exploreRepositoryProvider).getPlace(slug, cancelToken: _cancelOnDispose(ref));
});

final hospitalDetailProvider = FutureProvider.autoDispose.family<Hospital, String>((ref, id) {
  return ref.watch(exploreRepositoryProvider).getHospital(id, cancelToken: _cancelOnDispose(ref));
});

final hospitalDoctorsProvider = FutureProvider.autoDispose.family<List<Doctor>, String>((ref, id) {
  return ref.watch(exploreRepositoryProvider).getDoctors(id, cancelToken: _cancelOnDispose(ref));
});

final businessDetailProvider = FutureProvider.autoDispose.family<Business, String>((ref, slug) {
  return ref.watch(exploreRepositoryProvider).getBusiness(slug, cancelToken: _cancelOnDispose(ref));
});

final marketDetailProvider = FutureProvider.autoDispose.family<Market, String>((ref, id) {
  return ref.watch(exploreRepositoryProvider).getMarket(id, cancelToken: _cancelOnDispose(ref));
});
