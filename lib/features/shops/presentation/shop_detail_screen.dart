import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/remote_image.dart';
import '../../../core/widgets/verified_badge.dart';
import '../domain/shop.dart';
import 'shops_providers.dart';

/// Mirrors `frontend/app/(public)/shops/[id]/page.tsx`.
class ShopDetailScreen extends ConsumerWidget {
  const ShopDetailScreen({super.key, required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(shopDetailProvider(shopId));
    return Scaffold(
      appBar: AppBar(title: Text(value.valueOrNull?.name ?? '')),
      body: AsyncValueWidget<Shop>(
        value: value,
        onRetry: () => ref.invalidate(shopDetailProvider(shopId)),
        data: (shop) => _ShopBody(shop: shop),
      ),
    );
  }
}

class _ShopBody extends StatelessWidget {
  const _ShopBody({required this.shop});

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Chip(label: Text(shop.categoryName)),
        const SizedBox(height: 8),
        Text(shop.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => context.push(AppRoutes.market(shop.marketId)),
          child: Text(
            shop.marketName,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
          ),
        ),
        if ((shop.description ?? '').isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(shop.description!, style: theme.textTheme.bodyMedium),
        ],
        if ((shop.contactPhone ?? '').isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('${l10n.shopContactPhoneField}: ${shop.contactPhone}', style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Text(shop.seller.fullName, style: theme.textTheme.bodyMedium)),
            if (shop.seller.phoneVerified) const VerifiedBadge(),
          ],
        ),
        if (shop.images.isNotEmpty) ...[
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 4 / 3,
            ),
            itemCount: shop.images.length,
            itemBuilder: (context, index) => RemoteImage(
              url: shop.images[index],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ],
    );
  }
}
