import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/remote_image.dart';
import '../domain/shop.dart';
import 'shops_providers.dart';

/// Mirrors `frontend/components/shops/MyShops.tsx`.
class MyShopsScreen extends ConsumerWidget {
  const MyShopsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(myShopsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myShopsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: l10n.sellShopTitle,
            onPressed: () => context.push(AppRoutes.sellShop),
          ),
        ],
      ),
      body: AsyncValueWidget<List<Shop>>(
        value: value,
        onRetry: () => ref.invalidate(myShopsProvider),
        data: (shops) {
          if (shops.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmptyState(title: l10n.noShopsYet),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.push(AppRoutes.sellShop),
                    child: Text(l10n.sellShopTitle),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: shops.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) => _MyShopTile(shop: shops[index]),
          );
        },
      ),
    );
  }
}

class _MyShopTile extends StatelessWidget {
  const _MyShopTile({required this.shop});

  final Shop shop;

  Color? _moderationColor(BuildContext context, String status) {
    final scheme = Theme.of(context).colorScheme;
    return switch (status) {
      'approved' => Colors.green.shade100,
      'rejected' => scheme.errorContainer,
      _ => Colors.amber.shade100,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ListTile(
      leading: RemoteImage(
        url: shop.images.isNotEmpty ? shop.images.first : null,
        width: 56,
        height: 56,
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(shop.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${shop.marketName} · ${shop.categoryName}', maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            children: [
              Chip(
                label: Text(_moderationLabel(l10n, shop.moderationStatus), style: theme.textTheme.labelSmall),
                backgroundColor: _moderationColor(context, shop.moderationStatus),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              Chip(
                label: Text(
                  shop.status == 'active' ? l10n.shopStatusActive : l10n.shopStatusHidden,
                  style: theme.textTheme.labelSmall,
                ),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      ),
      isThreeLine: true,
      onTap: () => context.push(AppRoutes.shop(shop.id)),
    );
  }

  String _moderationLabel(AppLocalizations l10n, String status) => switch (status) {
        'approved' => l10n.moderationApproved,
        'rejected' => l10n.moderationRejected,
        _ => l10n.moderationPending,
      };
}
