import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/data/locations_repository.dart';
import '../../../core/models/location.dart';
import '../../explore/data/explore_repository.dart';
import '../../explore/domain/place.dart';
import '../data/representatives_repository.dart';
import '../domain/representative.dart';

CancelToken _cancelOnDispose(Ref<Object?> ref) {
  final token = CancelToken();
  ref.onDispose(token.cancel);
  return token;
}

/// This tenant's single upazila (matches the web app's single-upazila
/// assumption - `frontend/app/(public)/unions/page.tsx`).
final upazilaProvider = FutureProvider.autoDispose<AppLocation?>((ref) async {
  final upazilas = await ref
      .watch(locationsRepositoryProvider)
      .list(type: 'upazila', cancelToken: _cancelOnDispose(ref));
  return upazilas.isEmpty ? null : upazilas.first;
});

final unionsProvider = FutureProvider.autoDispose<List<AppLocation>>((ref) async {
  final upazila = await ref.watch(upazilaProvider.future);
  if (upazila == null) return const [];
  return ref
      .watch(locationsRepositoryProvider)
      .list(type: 'union', parentId: upazila.id, cancelToken: _cancelOnDispose(ref));
});

final villagesProvider = FutureProvider.autoDispose.family<List<AppLocation>, String>((ref, unionId) {
  return ref
      .watch(locationsRepositoryProvider)
      .list(type: 'village', parentId: unionId, cancelToken: _cancelOnDispose(ref));
});

final representativesByLocationProvider =
    FutureProvider.autoDispose.family<List<Representative>, String>((ref, locationId) {
  return ref.watch(representativesRepositoryProvider).list(locationId: locationId, cancelToken: _cancelOnDispose(ref));
});

final villagePlacesProvider = FutureProvider.autoDispose.family<List<Place>, String>((ref, villageId) {
  return ref
      .watch(exploreRepositoryProvider)
      .listPlacesByLocation(villageId, cancelToken: _cancelOnDispose(ref));
});

final representativeDetailProvider = FutureProvider.autoDispose.family<Representative, String>((ref, id) {
  return ref.watch(representativesRepositoryProvider).get(id, cancelToken: _cancelOnDispose(ref));
});

/// The signed-in user's own representative profile, if any (drives the
/// conditional "আমার প্রতিনিধি প্রোফাইল" entry on the Profile screen).
final myRepresentativeProvider = FutureProvider.autoDispose<Representative?>((ref) async {
  final auth = await ref.watch(authControllerProvider.future);
  if (!auth.isAuthenticated) return null;
  final mine = await ref
      .watch(representativesRepositoryProvider)
      .listMine(cancelToken: _cancelOnDispose(ref));
  return mine.isEmpty ? null : mine.first;
});
