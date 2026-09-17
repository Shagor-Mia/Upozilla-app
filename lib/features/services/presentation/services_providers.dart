import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services_repository.dart';
import '../domain/government_service.dart';

/// Triggers a manual `SyncEngine.syncAll()` on pull-to-refresh; the list
/// providers below read the offline-synced tables reactively and update on
/// their own once new data lands.
final servicesRefreshTickProvider = StateProvider<int>((ref) => 0);

final servicesListProvider = StreamProvider.autoDispose<List<GovernmentService>>((ref) {
  return ref.watch(servicesRepositoryProvider).watchServices();
});

final serviceCategoriesProvider = StreamProvider.autoDispose<List<ServiceCategory>>((ref) {
  return ref.watch(servicesRepositoryProvider).watchCategories();
});

final serviceDetailProvider = FutureProvider.autoDispose.family<GovernmentService, String>((ref, id) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(servicesRepositoryProvider).getService(id, cancelToken: cancelToken);
});
