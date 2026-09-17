import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/external_links.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/info_row.dart';
import '../domain/government_service.dart';
import 'services_providers.dart';

class ServiceDetailScreen extends ConsumerWidget {
  const ServiceDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(serviceDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(value.valueOrNull?.name ?? context.l10n.services)),
      body: AsyncValueWidget<GovernmentService>(
        value: value,
        onRetry: () => ref.invalidate(serviceDetailProvider(id)),
        data: (service) => _ServiceBody(service: service),
      ),
    );
  }
}

class _ServiceBody extends StatelessWidget {
  const _ServiceBody({required this.service});

  final GovernmentService service;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final link = service.officialLink;
    final contact = service.officeContact;
    final fee = service.fee;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(service.name, style: theme.textTheme.headlineSmall),
        if (service.description != null) ...[
          const SizedBox(height: 12),
          Text(service.description!, style: theme.textTheme.bodyLarge),
        ],
        const SizedBox(height: 8),
        InfoRow(icon: Icons.checklist_outlined, label: l10n.eligibility, value: service.eligibility),
        InfoRow(
          icon: Icons.description_outlined,
          label: l10n.requiredDocuments,
          value: service.requiredDocuments.isEmpty ? null : service.requiredDocuments.map((d) => '• $d').join('\n'),
        ),
        InfoRow(icon: Icons.payments_outlined, label: l10n.fee, value: fee == null ? null : Formatters.price(fee)),
        InfoRow(icon: Icons.account_balance_outlined, label: l10n.office, value: service.officeName),
        InfoRow(
          icon: Icons.phone_outlined,
          label: l10n.contact,
          value: contact,
          onTap: contact == null ? null : () => ExternalLinks.dial(contact),
        ),
        if (link != null) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => ExternalLinks.openUrl(link),
            icon: const Icon(Icons.open_in_new),
            label: Text(l10n.openWebsite),
          ),
        ],
      ],
    );
  }
}
