import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/offline/sync_engine.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../explore/domain/market.dart';
import '../../explore/presentation/explore_providers.dart';
import '../domain/shop.dart';
import 'shops_providers.dart';
import 'widgets/shop_card.dart';

/// Mirrors `frontend/app/(public)/markets/[id]/page.tsx`: market info +
/// description highlight + featured shops + full shop grid.
class MarketDetailScreen extends ConsumerWidget {
  const MarketDetailScreen({super.key, required this.marketId});

  final String marketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketValue = ref.watch(marketDetailProvider(marketId));
    return Scaffold(
      appBar: AppBar(title: Text(marketValue.valueOrNull?.name ?? '')),
      body: AsyncValueWidget<Market>(
        value: marketValue,
        onRetry: () => ref.invalidate(marketDetailProvider(marketId)),
        data: (market) => _MarketBody(market: market),
      ),
    );
  }
}

class _MarketBody extends ConsumerWidget {
  const _MarketBody({required this.market});

  final Market market;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final shopsValue = ref.watch(marketShopsProvider(market.id));

    final hours = [Formatters.clock(market.startTime), Formatters.clock(market.endTime)]
        .where((s) => s.isNotEmpty)
        .join(' – ');
    final days = market.marketDays.map(Formatters.humanize).join(', ');

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(syncEngineProvider).syncAll();
        ref.invalidate(marketShopsProvider(market.id));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Chip(label: Text(Formatters.humanize(market.type))),
          const SizedBox(height: 8),
          Text(market.name, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            [if (days.isNotEmpty) '${l10n.marketDays}: $days', if (hours.isNotEmpty) hours].join(' · '),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
          ),
          if ((market.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(market.description!, style: theme.textTheme.bodyMedium),
              ),
            ),
          ],
          const SizedBox(height: 24),
          AsyncValueWidget<List<Shop>>(
            value: shopsValue,
            onRetry: () => ref.invalidate(marketShopsProvider(market.id)),
            data: (shops) {
              final featured = shops.where((s) => s.isFeatured).toList();
              final rest = shops.where((s) => !s.isFeatured).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (featured.isNotEmpty) ...[
                    Text(l10n.featuredShops, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    _ShopGrid(shops: featured),
                    const SizedBox(height: 24),
                  ],
                  Text(l10n.shopsInMarket, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (shops.isEmpty)
                    Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(l10n.noShopsInMarket))
                  else if (rest.isEmpty)
                    Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Text(l10n.noOtherShops))
                  else
                    _ShopGrid(shops: rest),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ShopGrid extends StatelessWidget {
  const _ShopGrid({required this.shops});

  final List<Shop> shops;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: shops.length,
      itemBuilder: (context, index) => ShopCard(shop: shops[index]),
    );
  }
}
