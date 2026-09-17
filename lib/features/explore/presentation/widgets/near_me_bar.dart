import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/models/geo.dart';
import '../explore_providers.dart';

/// "Near me" toggle + radius chips shown above every explore tab.
///
/// TODO(mapbox): render results on a `mapbox_maps_flutter` map once a
/// `MAPBOX_TOKEN` exists (Section 9); lists are the Phase 3 baseline.
class NearMeBar extends ConsumerWidget {
  const NearMeBar({super.key});

  static const _radiusOptions = <double>[5, 10, 25, NearMeQuery.maxRadiusKm];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(nearMeEnabledProvider);
    final radius = ref.watch(nearMeRadiusKmProvider);
    final locating = enabled && ref.watch(nearMeQueryProvider).isLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilterChip(
                selected: enabled,
                avatar: locating
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.my_location_rounded, size: 18),
                label: Text(l10n.nearMe),
                onSelected: (value) => ref.read(nearMeEnabledProvider.notifier).state = value,
              ),
              const SizedBox(width: 8),
              if (!enabled)
                Expanded(
                  child: Text(
                    l10n.locationHint,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final option in _radiusOptions)
                  ChoiceChip(
                    selected: radius == option,
                    label: Text(l10n.nearMeRadius(option.toStringAsFixed(0))),
                    onSelected: (_) => ref.read(nearMeRadiusKmProvider.notifier).state = option,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
