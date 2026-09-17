import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/models/location.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart';
import 'unions_providers.dart';
import 'widgets/representatives_section.dart';

/// Mirrors `frontend/app/(public)/unions/[id]/page.tsx`: representatives +
/// villages grid. [initialUnion] comes from the list screen's `extra` (avoids
/// a redundant fetch); a cold-start deep link falls back to re-resolving the
/// name from [unionsProvider], same as the web app has to.
class UnionDetailScreen extends ConsumerWidget {
  const UnionDetailScreen({super.key, required this.unionId, this.initialUnion});

  final String unionId;
  final AppLocation? initialUnion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final unions = ref.watch(unionsProvider).valueOrNull ?? const <AppLocation>[];
    final matchedNames = unions.where((u) => u.id == unionId).map((u) => u.name);
    final resolvedName = initialUnion?.name ?? (matchedNames.isEmpty ? null : matchedNames.first);

    return Scaffold(
      appBar: AppBar(title: Text(resolvedName ?? '')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(representativesByLocationProvider(unionId));
          ref.invalidate(villagesProvider(unionId));
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            RepresentativesSection(locationId: unionId),
            const SizedBox(height: 24),
            Text(l10n.villagesTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            AsyncValueWidget<List<AppLocation>>(
              value: ref.watch(villagesProvider(unionId)),
              onRetry: () => ref.invalidate(villagesProvider(unionId)),
              data: (villages) {
                if (villages.isEmpty) return Text(l10n.emptyTitle);
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: villages.length,
                  itemBuilder: (context, index) {
                    final village = villages[index];
                    return Card(
                      child: InkWell(
                        onTap: () => context.push(AppRoutes.village(unionId, village.id), extra: village),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(village.name, textAlign: TextAlign.center),
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
