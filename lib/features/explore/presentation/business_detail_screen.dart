import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/external_links.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/distance_chip.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/remote_image.dart';
import '../../../core/widgets/verified_badge.dart';
import '../domain/business.dart';
import 'explore_providers.dart';

class BusinessDetailScreen extends ConsumerWidget {
  const BusinessDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(businessDetailProvider(slug));
    return Scaffold(
      appBar: AppBar(title: Text(value.valueOrNull?.name ?? '')),
      body: AsyncValueWidget<Business>(
        value: value,
        onRetry: () => ref.invalidate(businessDetailProvider(slug)),
        data: (business) => _BusinessBody(business: business),
      ),
    );
  }
}

class _BusinessBody extends StatelessWidget {
  const _BusinessBody({required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final phone = business.phone;
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (business.coverImage != null) RemoteImage(url: business.coverImage, height: 200),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (business.logo != null) ...[
                    RemoteImage(url: business.logo, width: 48, height: 48, borderRadius: BorderRadius.circular(24)),
                    const SizedBox(width: 12),
                  ],
                  Expanded(child: Text(business.name, style: theme.textTheme.headlineSmall)),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(label: Text(Formatters.humanize(business.category))),
                  if (business.isVerified) const VerifiedBadge(),
                  DistanceChip(distanceKm: business.distanceKm),
                ],
              ),
              if (business.description != null) ...[
                const SizedBox(height: 16),
                Text(business.description!, style: theme.textTheme.bodyLarge),
              ],
              const SizedBox(height: 8),
              InfoRow(icon: Icons.place_outlined, label: l10n.address, value: business.address),
              InfoRow(
                icon: Icons.phone_outlined,
                label: l10n.contact,
                value: phone,
                onTap: phone == null ? null : () => ExternalLinks.dial(phone),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
