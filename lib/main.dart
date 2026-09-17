import 'bootstrap/bootstrap.dart';
import 'core/config/app_config.dart';

/// Default entrypoint: picks the flavor from `--dart-define=FLAVOR=...`
/// (defaults to dev). Prefer the explicit `bootstrap/main_<flavor>.dart`
/// targets in IDE run configurations and CI.
Future<void> main() {
  const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  return bootstrap(flavor: AppConfig.flavorFromString(flavorName));
}
