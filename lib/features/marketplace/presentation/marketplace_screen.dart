import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/online_only_gate.dart';
import 'marketplace_providers.dart';
import 'widgets/listing_card.dart';
import 'widgets/listing_grid.dart';

/// Local Bazar (B2C) and Exchange (C2C) tabs with a shared search box.
class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  static const _debounce = Duration(milliseconds: 400);

  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.text = ref.read(listingSearchProvider);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounce, () {
      ref.read(listingSearchProvider.notifier).state = text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navMarketplace),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(112),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l10n.searchListings,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      ),
                    ),
                  ),
                ),
                TabBar(tabs: [Tab(text: l10n.localBazar), Tab(text: l10n.exchange)]),
              ],
            ),
          ),
        ),
        // Local Bazar / Exchange listings churn quickly and are never
        // synced offline by design (Section: offline-first plan) - gate the
        // whole screen instead of letting every request fail silently.
        body: const OnlineOnlyGate(child: TabBarView(children: [_ProductsTab(), _ExchangeTab()])),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push(AppRoutes.sell),
          icon: const Icon(Icons.add),
          label: Text(l10n.sellSomething),
        ),
      ),
    );
  }
}

class _ProductsTab extends ConsumerWidget {
  const _ProductsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(listingQueryProvider);
    final provider = productsProvider(query);
    return ListingGrid(
      value: ref.watch(provider),
      onLoadMore: () => ref.read(provider.notifier).loadMore(),
      onRefresh: () => ref.refresh(provider.future).then((_) {}, onError: (_) {}),
      itemBuilder: (product) => ListingCard(
        title: product.title,
        price: product.price,
        currency: product.currency,
        locationName: product.locationName,
        condition: product.condition,
        imageUrl: product.coverImage,
        onTap: () => context.push(AppRoutes.product(product.id)),
      ),
    );
  }
}

class _ExchangeTab extends ConsumerWidget {
  const _ExchangeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(listingQueryProvider);
    final provider = exchangeListingsProvider(query);
    return ListingGrid(
      value: ref.watch(provider),
      onLoadMore: () => ref.read(provider.notifier).loadMore(),
      onRefresh: () => ref.refresh(provider.future).then((_) {}, onError: (_) {}),
      itemBuilder: (listing) => ListingCard(
        title: listing.title,
        price: listing.price,
        currency: listing.currency,
        locationName: listing.locationName,
        condition: listing.condition,
        imageUrl: listing.coverImage,
        isNegotiable: listing.isNegotiable,
        onTap: () => context.push(AppRoutes.exchange(listing.id)),
      ),
    );
  }
}
