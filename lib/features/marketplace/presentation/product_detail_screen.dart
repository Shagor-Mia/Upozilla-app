import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../domain/product.dart';
import 'marketplace_providers.dart';
import 'widgets/listing_actions.dart';
import 'widgets/listing_detail_body.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(productDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.localBazar)),
      body: AsyncValueWidget<Product>(
        value: value,
        onRetry: () => ref.invalidate(productDetailProvider(id)),
        data: (product) => ListingDetailBody(
          title: product.title,
          price: product.price,
          currency: product.currency,
          condition: product.condition,
          categoryName: product.categoryName,
          locationName: product.locationName,
          images: product.images,
          seller: product.seller,
          description: product.description,
          businessName: product.businessName,
          createdAt: product.createdAt,
          footer: ListingActions(
            listingType: product.listingType,
            listingId: product.id,
            sellerId: product.seller.id,
            isFavorited: product.isFavorited,
            favoritesCount: product.favoritesCount,
          ),
        ),
      ),
    );
  }
}
