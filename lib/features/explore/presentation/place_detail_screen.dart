import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/distance_chip.dart';
import '../../../core/widgets/remote_image.dart';
import '../domain/place.dart';
import 'explore_providers.dart';

class PlaceDetailScreen extends ConsumerWidget {
  const PlaceDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(placeDetailProvider(slug));
    return Scaffold(
      appBar: AppBar(title: Text(value.valueOrNull?.name ?? '')),
      body: AsyncValueWidget<Place>(
        value: value,
        onRetry: () => ref.invalidate(placeDetailProvider(slug)),
        data: (place) => _PlaceBody(place: place),
      ),
    );
  }
}

class _PlaceBody extends StatelessWidget {
  const _PlaceBody({required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final images = [if (place.coverImage != null) place.coverImage!, ...place.gallery];
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (images.isNotEmpty)
          SizedBox(
            height: 220,
            child: PageView.builder(
              itemCount: images.length,
              itemBuilder: (_, index) => RemoteImage(url: images[index], height: 220),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(place.name, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(label: Text(Formatters.humanize(place.category))),
                  if (place.isFeatured) Chip(avatar: const Icon(Icons.star_rounded, size: 18), label: Text(l10n.featured)),
                  DistanceChip(distanceKm: place.distanceKm),
                ],
              ),
              if (place.description != null) ...[
                const SizedBox(height: 16),
                Text(place.description!, style: theme.textTheme.bodyLarge),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
