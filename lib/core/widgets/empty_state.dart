import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.title, this.body, this.icon = Icons.inbox_outlined});

  final String? title;
  final String? body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(title ?? l10n.emptyTitle, style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              body ?? l10n.emptyBody,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
