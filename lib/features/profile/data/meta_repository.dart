import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../domain/app_meta.dart';

class MetaRepository {
  MetaRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<AppMeta> getMeta() async {
    final json = await _api.get(ApiPaths.meta);
    return AppMeta.fromJson(asJsonObject(json));
  }
}

final metaRepositoryProvider = Provider<MetaRepository>((ref) {
  return MetaRepository(api: ref.watch(apiClientProvider));
});
