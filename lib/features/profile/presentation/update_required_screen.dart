import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/external_links.dart';

/// Blocking screen shown when the installed version is below the backend's
/// `min_supported_app_version`. There is no way past it by design.
class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key, this.latestVersion});

  final String? latestVersion;

  // TODO(release): replace with the real store listings once published.
  static const _storeUrl = 'https://play.google.com/store/apps/details?id=com.upazila.upazila_app';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.system_update_rounded, size: 72, color: theme.colorScheme.primary),
                const SizedBox(height: 24),
                Text(l10n.updateRequiredTitle, style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text(l10n.updateRequiredBody, style: theme.textTheme.bodyLarge, textAlign: TextAlign.center),
                if (latestVersion != null && latestVersion!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(l10n.appVersion(latestVersion!), style: theme.textTheme.bodySmall),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => ExternalLinks.openUrl(_storeUrl),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.updateNow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
