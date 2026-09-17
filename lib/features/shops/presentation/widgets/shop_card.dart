import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../domain/shop.dart';

/// Text-only shop card used in the market detail grid (matches
/// `frontend/components/shops/ShopCard.tsx` - no image there).
class ShopCard extends StatelessWidget {
  const ShopCard({super.key, required this.shop});

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => context.push(AppRoutes.shop(shop.id)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (shop.isFeatured) ...[
                    Icon(Icons.star_rounded, size: 16, color: theme.colorScheme.tertiary),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(shop.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(shop.categoryName, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline)),
              if ((shop.description ?? '').isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  shop.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
