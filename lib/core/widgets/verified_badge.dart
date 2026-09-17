import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// Business verification badge (Phase 3 "business verification badges").
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final icon = Icon(Icons.verified_rounded, size: compact ? 16 : 18, color: scheme.primary);
    if (compact) return icon;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 4),
        Text(
          context.l10n.verified,
          style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600, fontSize: 12),
        ),
      ],
    );
  }
}
