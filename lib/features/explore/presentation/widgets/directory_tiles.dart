import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/distance_chip.dart';
import '../../../../core/widgets/remote_image.dart';
import '../../../../core/widgets/verified_badge.dart';
import '../../domain/business.dart';
import '../../domain/hospital.dart';
import '../../domain/market.dart';
import '../../domain/place.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RemoteImage(url: place.coverImage, width: 56, height: 56, borderRadius: BorderRadius.circular(8)),
      title: Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(Formatters.humanize(place.category)),
      trailing: _Trailing(distanceKm: place.distanceKm, featured: place.isFeatured),
      onTap: () => context.push(AppRoutes.place(place.slug)),
    );
  }
}

class HospitalTile extends StatelessWidget {
  const HospitalTile({super.key, required this.hospital});

  final Hospital hospital;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.local_hospital_outlined)),
      title: Text(hospital.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [Formatters.humanize(hospital.type), if (hospital.address != null) hospital.address!].join(' · '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: DistanceChip(distanceKm: hospital.distanceKm),
      onTap: () => context.push(AppRoutes.hospital(hospital.id)),
    );
  }
}

class MarketTile extends StatelessWidget {
  const MarketTile({super.key, required this.market});

  final Market market;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hours = [Formatters.clock(market.startTime), Formatters.clock(market.endTime)]
        .where((s) => s.isNotEmpty)
        .join(' – ');
    final days = market.marketDays.map(Formatters.humanize).join(', ');
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.storefront_outlined)),
      title: Text(market.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [
          Formatters.humanize(market.type),
          if (days.isNotEmpty) '${l10n.marketDays}: $days',
          if (hours.isNotEmpty) hours,
        ].join(' · '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: DistanceChip(distanceKm: market.distanceKm),
      onTap: () => context.push(AppRoutes.market(market.id)),
    );
  }
}

class BusinessTile extends StatelessWidget {
  const BusinessTile({super.key, required this.business});

  final Business business;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: RemoteImage(
        url: business.logo ?? business.coverImage,
        width: 56,
        height: 56,
        borderRadius: BorderRadius.circular(8),
      ),
      title: Row(
        children: [
          Flexible(child: Text(business.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
          if (business.isVerified) ...[const SizedBox(width: 4), const VerifiedBadge(compact: true)],
        ],
      ),
      subtitle: Text(
        [Formatters.humanize(business.category), if (business.address != null) business.address!].join(' · '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: DistanceChip(distanceKm: business.distanceKm),
      onTap: () => context.push(AppRoutes.business(business.slug)),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.distanceKm, required this.featured});

  final double? distanceKm;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    if (distanceKm != null) return DistanceChip(distanceKm: distanceKm);
    if (featured) return Icon(Icons.star_rounded, color: Theme.of(context).colorScheme.tertiary);
    return const SizedBox.shrink();
  }
}
