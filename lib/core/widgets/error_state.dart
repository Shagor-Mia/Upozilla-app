import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry, this.isOffline = false});

  final String message;
  final VoidCallback? onRetry;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOffline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(onPressed: onRetry, child: Text(context.l10n.retry)),
            ],
          ],
        ),
      ),
    );
  }
}
