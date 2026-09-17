import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/seller_summary.dart';

class SellerCard extends StatelessWidget {
  const SellerCard({super.key, required this.seller, this.onTap});

  final SellerSummary seller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final since = seller.memberSince;
    final rating = seller.avgRating;
    return Card(
      child: ListTile(
        onTap: onTap,
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
        leading: CircleAvatar(child: Text(seller.fullName.isEmpty ? '?' : seller.fullName[0].toUpperCase())),
        title: Row(
          children: [
            Flexible(child: Text(seller.fullName, maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (seller.phoneVerified) ...[
              const SizedBox(width: 4),
              Icon(Icons.verified_user_rounded, size: 16, color: theme.colorScheme.primary),
            ],
          ],
        ),
        subtitle: Text(
          [
            l10n.sellerLabel,
            if (since != null) l10n.memberSince(Formatters.date(since, locale: locale)),
            if (rating != null) '★ ${rating.toStringAsFixed(1)} (${seller.reviewCount})',
            if (seller.phoneMasked != null) seller.phoneMasked!,
          ].join(' · '),
        ),
      ),
    );
  }
}
