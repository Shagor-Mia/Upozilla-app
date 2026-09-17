import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../domain/exchange_listing.dart';
import 'marketplace_providers.dart';
import 'widgets/listing_actions.dart';
import 'widgets/listing_detail_body.dart';

class ExchangeDetailScreen extends ConsumerWidget {
  const ExchangeDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(exchangeDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.exchange)),
      body: AsyncValueWidget<ExchangeListing>(
        value: value,
        onRetry: () => ref.invalidate(exchangeDetailProvider(id)),
        data: (listing) => ListingDetailBody(
          title: listing.title,
          price: listing.price,
          currency: listing.currency,
          condition: listing.condition,
          categoryName: listing.categoryName,
          locationName: listing.locationName,
          images: listing.images,
          seller: listing.seller,
          description: listing.description,
          isNegotiable: listing.isNegotiable,
          createdAt: listing.createdAt,
          footer: ListingActions(
            listingType: listing.listingType,
            listingId: listing.id,
            sellerId: listing.seller.id,
            isFavorited: listing.isFavorited,
            favoritesCount: listing.favoritesCount,
          ),
        ),
      ),
    );
  }
}
