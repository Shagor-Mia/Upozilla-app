import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/remote_image.dart';

/// Grid card shared by product and exchange lists. Takes plain values so the
/// widget does not care which listing model it renders.
class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.title,
    required this.price,
    required this.currency,
    required this.locationName,
    required this.condition,
    required this.onTap,
    this.imageUrl,
    this.isNegotiable = false,
  });

  final String title;
  final double price;
  final String currency;
  final String locationName;
  final String condition;
  final String? imageUrl;
  final bool isNegotiable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 4 / 3, child: RemoteImage(url: imageUrl)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.price(price, currency: currency),
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [Formatters.humanize(condition), if (isNegotiable) l10n.negotiable, locationName]
                        .where((s) => s.isNotEmpty)
                        .join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
