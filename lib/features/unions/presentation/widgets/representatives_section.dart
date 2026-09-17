import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/representative.dart';
import '../unions_providers.dart';
import 'representative_tile.dart';

/// Representatives list for a location (union or village), used by both
/// [UnionDetailScreen] and [VillageDetailScreen].
class RepresentativesSection extends ConsumerWidget {
  const RepresentativesSection({super.key, required this.locationId});

  final String locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(representativesByLocationProvider(locationId));
    return AsyncValueWidget<List<Representative>>(
      value: value,
      onRetry: () => ref.invalidate(representativesByLocationProvider(locationId)),
      data: (reps) {
        if (reps.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.representativesTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final rep in reps) RepresentativeTile(representative: rep),
          ],
        );
      },
    );
  }
}
