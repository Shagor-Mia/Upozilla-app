import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/observability/logger.dart';
import '../../../core/utils/semver.dart';
import '../data/meta_repository.dart';
import '../domain/app_meta.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

final appMetaProvider = FutureProvider<AppMeta>((ref) => ref.watch(metaRepositoryProvider).getMeta());

/// Section 8.7 gate. Fails open: if `/meta` cannot be reached (offline, old
/// backend without the route) the app keeps working rather than locking the
/// user out on a network blip.
final updateRequiredProvider = FutureProvider<bool>((ref) async {
  final info = await ref.watch(packageInfoProvider.future);
  try {
    final meta = await ref.watch(appMetaProvider.future);
    final required = isUpdateRequired(installed: info.version, minimumSupported: meta.minSupportedAppVersion);
    AppLogger.info(
      'version gate',
      tag: 'meta',
      fields: {'installed': info.version, 'min': meta.minSupportedAppVersion, 'blocked': required},
    );
    return required;
  } on AppException catch (e) {
    AppLogger.warn('meta unavailable; skipping version gate', tag: 'meta', fields: {'reason': e.runtimeType});
    return false;
  }
});
