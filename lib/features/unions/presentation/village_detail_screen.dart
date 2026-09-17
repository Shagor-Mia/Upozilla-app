import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/models/location.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../explore/domain/place.dart';
import 'unions_providers.dart';
import 'widgets/representatives_section.dart';

/// Mirrors `frontend/app/(public)/unions/[id]/villages/[villageId]/page.tsx`:
/// ward representatives + places grid. [initialVillage] comes from the union
/// screen's `extra`; falls back to re-resolving via [villagesProvider] on a
/// cold-start deep link, same as the web app.
class VillageDetailScreen extends ConsumerWidget {
  const VillageDetailScreen({super.key, required this.unionId, required this.villageId, this.initialVillage});

  final String unionId;
  final String villageId;
  final AppLocation? initialVillage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final villages = ref.watch(villagesProvider(unionId)).valueOrNull ?? const <AppLocation>[];
    final matchedNames = villages.where((v) => v.id == villageId).map((v) => v.name);
    final resolvedName = initialVillage?.name ?? (matchedNames.isEmpty ? null : matchedNames.first);

    return Scaffold(
      appBar: AppBar(title: Text(resolvedName ?? '')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(representativesByLocationProvider(villageId));
          ref.invalidate(villagePlacesProvider(villageId));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            RepresentativesSection(locationId: villageId),
            const SizedBox(height: 24),
            Text(l10n.villagePlacesTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            AsyncValueWidget<List<Place>>(
              value: ref.watch(villagePlacesProvider(villageId)),
              onRetry: () => ref.invalidate(villagePlacesProvider(villageId)),
              data: (places) {
                if (places.isEmpty) return Text(l10n.emptyTitle);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return Card(
                      child: InkWell(
                        onTap: () => context.push(AppRoutes.place(place.slug)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
                              const SizedBox(height: 4),
                              Text(Formatters.humanize(place.category), style: Theme.of(context).textTheme.labelSmall),
                              if ((place.description ?? '').isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  place.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
