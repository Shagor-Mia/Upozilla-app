import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/snackbars.dart';
import '../data/marketplace_repository.dart';
import '../domain/exchange_listing.dart';
import '../domain/product.dart';
import 'marketplace_providers.dart';

/// `GET .../mine` for both listing kinds, each row offering a status change
/// (active/sold) and delete - the minimum "manage your own listing" surface.
class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.myListings),
          bottom: TabBar(tabs: [Tab(text: l10n.localBazar), Tab(text: l10n.exchange)]),
        ),
        body: const TabBarView(children: [_MyProductsTab(), _MyExchangeTab()]),
      ),
    );
  }
}

class _MyProductsTab extends ConsumerWidget {
  const _MyProductsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(myProductsProvider);
    return AsyncValueWidget<List<Product>>(
      value: value,
      onRetry: () => ref.invalidate(myProductsProvider),
      data: (products) {
        if (products.isEmpty) return EmptyState(title: l10n.noListingsYet);
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: products.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final product = products[index];
            return _MyListingTile(
              title: product.title,
              price: Formatters.price(product.price, currency: product.currency),
              status: product.status,
              onTap: () => context.push(AppRoutes.product(product.id)),
              onMarkSold: product.status == 'active'
                  ? () async {
                      try {
                        await ref
                            .read(marketplaceRepositoryProvider)
                            .updateProductStatus(product.id, status: 'sold');
                        ref.invalidate(myProductsProvider);
                      } on AppException catch (e) {
                        if (context.mounted) showErrorSnackBar(context, e);
                      }
                    }
                  : null,
              onDelete: () => _confirmDelete(context, ref, () async {
                await ref.read(marketplaceRepositoryProvider).deleteProduct(product.id);
                ref.invalidate(myProductsProvider);
              }),
            );
          },
        );
      },
    );
  }
}

class _MyExchangeTab extends ConsumerWidget {
  const _MyExchangeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(myExchangeListingsProvider);
    return AsyncValueWidget<List<ExchangeListing>>(
      value: value,
      onRetry: () => ref.invalidate(myExchangeListingsProvider),
      data: (listings) {
        if (listings.isEmpty) return EmptyState(title: l10n.noListingsYet);
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: listings.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final listing = listings[index];
            return _MyListingTile(
              title: listing.title,
              price: Formatters.price(listing.price, currency: listing.currency),
              status: listing.status,
              onTap: () => context.push(AppRoutes.exchange(listing.id)),
              onMarkSold: listing.status == 'active'
                  ? () async {
                      try {
                        await ref
                            .read(marketplaceRepositoryProvider)
                            .updateExchangeListingStatus(listing.id, status: 'sold');
                        ref.invalidate(myExchangeListingsProvider);
                      } on AppException catch (e) {
                        if (context.mounted) showErrorSnackBar(context, e);
                      }
                    }
                  : null,
              onDelete: () => _confirmDelete(context, ref, () async {
                await ref.read(marketplaceRepositoryProvider).deleteExchangeListing(listing.id);
                ref.invalidate(myExchangeListingsProvider);
              }),
            );
          },
        );
      },
    );
  }
}

Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Future<void> Function() onConfirm) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.deleteListingTitle),
      content: Text(l10n.deleteListingBody),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
        FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.delete)),
      ],
    ),
  );
  if (confirmed != true) return;
  try {
    await onConfirm();
  } on AppException catch (e) {
    if (context.mounted) showErrorSnackBar(context, e);
  }
}

class _MyListingTile extends StatelessWidget {
  const _MyListingTile({
    required this.title,
    required this.price,
    required this.status,
    required this.onTap,
    required this.onDelete,
    this.onMarkSold,
  });

  final String title;
  final String price;
  final String status;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onMarkSold;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      onTap: onTap,
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Row(
        children: [
          Text(price),
          const SizedBox(width: 8),
          Chip(
            label: Text(Formatters.humanize(status), style: Theme.of(context).textTheme.labelSmall),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'sold') onMarkSold?.call();
          if (value == 'delete') onDelete();
        },
        itemBuilder: (context) => [
          if (onMarkSold != null) PopupMenuItem(value: 'sold', child: Text(l10n.markSold)),
          PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
        ],
      ),
    );
  }
}
