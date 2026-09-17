import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../domain/favorites.dart';
import 'marketplace_providers.dart';
import 'widgets/listing_card.dart';

/// `GET /exchange/favorites` - saved listings across both kinds, rendered
/// with the same [ListingCard] the marketplace grids use.
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(favoritesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: AsyncValueWidget<Favorites>(
        value: value,
        onRetry: () => ref.invalidate(favoritesProvider),
        data: (favorites) {
          if (favorites.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(favoritesProvider.future).then((_) {}, onError: (_) {}),
              child: ListView(
                children: [const SizedBox(height: 120), EmptyState(icon: Icons.favorite_border, title: l10n.noFavoritesYet)],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(favoritesProvider.future).then((_) {}, onError: (_) {}),
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (favorites.marketplace.isNotEmpty) ...[
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(l10n.localBazar, style: Theme.of(context).textTheme.titleMedium)),
                  const SizedBox(height: 8),
                  _FavoritesGrid(
                    count: favorites.marketplace.length,
                    itemBuilder: (index) {
                      final product = favorites.marketplace[index];
                      return ListingCard(
                        title: product.title,
                        price: product.price,
                        currency: product.currency,
                        locationName: product.locationName,
                        condition: product.condition,
                        imageUrl: product.coverImage,
                        onTap: () => context.push(AppRoutes.product(product.id)),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                if (favorites.exchange.isNotEmpty) ...[
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Text(l10n.exchange, style: Theme.of(context).textTheme.titleMedium)),
                  const SizedBox(height: 8),
                  _FavoritesGrid(
                    count: favorites.exchange.length,
                    itemBuilder: (index) {
                      final listing = favorites.exchange[index];
                      return ListingCard(
                        title: listing.title,
                        price: listing.price,
                        currency: listing.currency,
                        locationName: listing.locationName,
                        condition: listing.condition,
                        imageUrl: listing.coverImage,
                        isNegotiable: listing.isNegotiable,
                        onTap: () => context.push(AppRoutes.exchange(listing.id)),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FavoritesGrid extends StatelessWidget {
  const _FavoritesGrid({required this.count, required this.itemBuilder});

  final int count;
  final Widget Function(int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}
