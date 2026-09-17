import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/models/location.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import 'unions_providers.dart';

/// Mirrors `frontend/app/(public)/unions/page.tsx`.
class UnionsListScreen extends ConsumerWidget {
  const UnionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(unionsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.unionsTitle)),
      body: AsyncValueWidget<List<AppLocation>>(
        value: value,
        onRetry: () => ref.invalidate(unionsProvider),
        data: (unions) {
          if (unions.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(unionsProvider),
              child: ListView(children: const [EmptyState()]),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(unionsProvider),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemCount: unions.length,
              itemBuilder: (context, index) {
                final union = unions[index];
                return Card(
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.union(union.id), extra: union),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(union.name, textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
