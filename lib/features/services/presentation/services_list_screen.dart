import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/offline/sync_engine.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../domain/government_service.dart';
import 'services_providers.dart';

class ServicesListScreen extends ConsumerWidget {
  const ServicesListScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.read(servicesRefreshTickProvider.notifier).state++;
    await ref.read(syncEngineProvider).syncAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(serviceCategoriesProvider).valueOrNull ?? const <ServiceCategory>[];
    final categoryNames = {for (final c in categories) c.id: c.name};
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.servicesTitle)),
      body: AsyncValueWidget<List<GovernmentService>>(
        value: ref.watch(servicesListProvider),
        onRetry: () => _refresh(ref),
        data: (services) => RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: services.isEmpty
              ? ListView(children: const [SizedBox(height: 120), EmptyState()])
              : ListView.separated(
                  itemCount: services.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final service = services[index];
                    final subtitle = [
                      if (categoryNames[service.categoryId] != null) categoryNames[service.categoryId]!,
                      if (service.officeName != null) service.officeName!,
                    ].join(' · ');
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.account_balance_outlined)),
                      title: Text(service.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: subtitle.isEmpty ? null : Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => context.push(AppRoutes.service(service.id)),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
