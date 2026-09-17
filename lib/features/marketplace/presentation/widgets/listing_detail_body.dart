import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../domain/seller_summary.dart';
import 'seller_card.dart';

/// Detail layout shared by product and exchange screens (image pager, price,
/// meta chips, description, seller, buyer action footer).
class ListingDetailBody extends StatelessWidget {
  const ListingDetailBody({
    super.key,
    required this.title,
    required this.price,
    required this.currency,
    required this.condition,
    required this.categoryName,
    required this.locationName,
    required this.images,
    required this.seller,
    this.description,
    this.isNegotiable = false,
    this.businessName,
    this.createdAt,
    this.footer,
  });

  final String title;
  final double price;
  final String currency;
  final String condition;
  final String categoryName;
  final String locationName;
  final List<String> images;
  final SellerSummary seller;
  final String? description;
  final bool isNegotiable;
  final String? businessName;
  final DateTime? createdAt;

  /// Rendered below the seller card - buyer actions (message/contact/save/report)
  /// live here so this widget stays a plain read-only layout otherwise.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        SizedBox(
          height: 260,
          child: images.isEmpty
              ? const RemoteImage(url: null, height: 260)
              : PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (_, index) => RemoteImage(url: images[index], height: 260),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Formatters.price(price, currency: currency),
                style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 4),
              Text(title, style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Chip(label: Text('${l10n.condition}: ${Formatters.humanize(condition)}')),
                  Chip(label: Text(categoryName)),
                  Chip(avatar: const Icon(Icons.place_outlined, size: 18), label: Text(locationName)),
                  if (isNegotiable) Chip(label: Text(l10n.negotiable)),
                  if (businessName != null) Chip(avatar: const Icon(Icons.store_outlined, size: 18), label: Text(businessName!)),
                ],
              ),
              if (createdAt != null) ...[
                const SizedBox(height: 8),
                Text(Formatters.dateTime(createdAt!, locale: locale), style: theme.textTheme.bodySmall),
              ],
              if (description != null && description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(description!, style: theme.textTheme.bodyLarge),
              ],
              const SizedBox(height: 16),
              SellerCard(seller: seller, onTap: () => context.push(AppRoutes.seller(seller.id))),
              if (footer != null) ...[
                const SizedBox(height: 16),
                footer!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
