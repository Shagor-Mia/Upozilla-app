import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/l10n.dart';
import '../network/connectivity.dart';

/// Blocks a feature that only works online (marketplace, exchange,
/// messaging, AI chat - Section: offline-first plan) with a clear "needs
/// internet" state instead of a broken/loading screen. Mirrors the
/// `_VersionGate` full-screen-gate pattern in `app/app.dart`.
class OnlineOnlyGate extends ConsumerWidget {
  const OnlineOnlyGate({super.key, required this.child, this.message});

  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider).valueOrNull ?? false;
    if (!isOffline) return child;
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              message ?? context.l10n.onlineOnlyFeature,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
