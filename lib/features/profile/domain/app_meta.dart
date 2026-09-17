/// `GET /meta` — backend-published compatibility window (Section 8.7).
class AppMeta {
  const AppMeta({
    required this.apiVersion,
    required this.minSupportedAppVersion,
    required this.latestAppVersion,
  });

  final String apiVersion;
  final String minSupportedAppVersion;
  final String latestAppVersion;

  factory AppMeta.fromJson(Map<String, dynamic> json) => AppMeta(
        apiVersion: json['api_version'] as String? ?? '',
        minSupportedAppVersion: json['min_supported_app_version'] as String? ?? '0.0.0',
        latestAppVersion: json['latest_app_version'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'api_version': apiVersion,
        'min_supported_app_version': minSupportedAppVersion,
        'latest_app_version': latestAppVersion,
      };
}
