import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/contract.dart';

/// List tile used on the "My Contracts" screen.
class ContractCard extends StatelessWidget {
  const ContractCard({super.key, required this.contract, required this.currentUserId});

  final WorkContract contract;
  final String? currentUserId;

  Color? _statusColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (contract.status) {
      'active' => Colors.green.shade100,
      'completed' => scheme.primaryContainer,
      'rejected' || 'cancelled' => scheme.errorContainer,
      'disputed' => Colors.amber.shade100,
      _ => scheme.surfaceContainerHighest,
    };
  }

  String _statusLabel(AppLocalizations l10n) => switch (contract.status) {
        'active' => l10n.contractStatusActive,
        'rejected' => l10n.contractStatusRejected,
        'cancelled' => l10n.contractStatusCancelled,
        'disputed' => l10n.contractStatusDisputed,
        'completed' => l10n.contractStatusCompleted,
        _ => l10n.contractStatusPending,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isEmployer = contract.isEmployer(currentUserId);
    final otherParty = contract.otherPartyName(currentUserId);
    final roleLabel = isEmployer ? l10n.contractWorkerLabel : l10n.contractEmployerLabel;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: () => context.push(AppRoutes.contract(contract.id)),
        title: Text(contract.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '$roleLabel: ${otherParty?.isNotEmpty == true ? otherParty : '-'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(Formatters.price(contract.paymentAmount, currency: contract.currency)),
          ],
        ),
        isThreeLine: true,
        trailing: Chip(
          label: Text(_statusLabel(l10n), style: theme.textTheme.labelSmall),
          backgroundColor: _statusColor(context),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
