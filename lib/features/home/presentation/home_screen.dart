import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/offline/sync_engine.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/remote_image.dart';
import '../../../core/widgets/section_header.dart';
import '../domain/featured_place.dart';
import '../domain/recommendations.dart';
import 'home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Featured places refresh on their own once new data lands (reactive
  /// local read); this pull only needs to (a) kick a fresh network sync and
  /// (b) refetch `recommendations`, which stays a plain online-only fetch.
  Future<void> _refresh(WidgetRef ref) async {
    ref.read(homeRefreshTickProvider.notifier).state++;
    await ref.read(syncEngineProvider).syncAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: l10n.notifications,
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          children: [
            SectionHeader(title: l10n.featuredPlaces),
            SizedBox(
              height: 190,
              child: AsyncValueWidget<List<FeaturedPlace>>(
                value: ref.watch(featuredPlacesProvider),
                onRetry: () => _refresh(ref),
                data: (places) => places.isEmpty
                    ? Center(child: Text(l10n.emptyTitle))
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: places.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, index) => _FeaturedCard(place: places[index]),
                      ),
              ),
            ),
            _ForYouSection(),
            SectionHeader(title: l10n.quickLinks),
            _QuickLinks(),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.place});

  final FeaturedPlace place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 240,
      child: Card(
        child: InkWell(
          onTap: () => context.push(AppRoutes.place(place.slug)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: RemoteImage(url: place.coverImage, width: double.infinity)),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
                    Text(Formatters.humanize(place.category), style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final links = <_QuickLink>[
      _QuickLink(Icons.local_hospital_outlined, l10n.tabHospitals, '${AppRoutes.explore}?tab=hospitals'),
      _QuickLink(Icons.storefront_outlined, l10n.tabMarkets, '${AppRoutes.explore}?tab=markets'),
      _QuickLink(Icons.store_outlined, l10n.tabBusinesses, '${AppRoutes.explore}?tab=businesses'),
      _QuickLink(Icons.account_balance_outlined, l10n.services, AppRoutes.servicesList),
      _QuickLink(Icons.shopping_bag_outlined, l10n.localBazar, AppRoutes.marketplace),
      _QuickLink(Icons.newspaper_outlined, l10n.navNews, AppRoutes.news),
      _QuickLink(Icons.help_outline, l10n.faqsTitle, AppRoutes.faqs),
      _QuickLink(Icons.groups_outlined, l10n.unionsTitle, AppRoutes.unions),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        for (final link in links)
          Card(
            child: InkWell(
              onTap: () =>
                  (link.path.startsWith(AppRoutes.servicesList) ||
                          link.path == AppRoutes.faqs ||
                          link.path == AppRoutes.unions)
                      ? context.push(link.path)
                      : context.go(link.path),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(link.icon, size: 28),
                  const SizedBox(height: 8),
                  Text(link.label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _QuickLink {
  const _QuickLink(this.icon, this.label, this.path);

  final IconData icon;
  final String label;
  final String path;
}

/// Section 17 Phase 4 "For You" - trending marketplace/exchange listings +
/// nearby hospitals from `GET /recommendations`. Supplementary content: while
/// loading or on error it renders nothing (never breaks the home screen),
/// same posture as `frontend/components/home/ForYouSection.tsx`.
class _ForYouSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final recommendations = ref.watch(recommendationsProvider).valueOrNull;
    if (recommendations == null || (recommendations.listings.isEmpty && recommendations.hospitals.isEmpty)) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.forYou),
        if (recommendations.listings.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(l10n.forYouTrending, style: Theme.of(context).textTheme.labelLarge),
          ),
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: recommendations.listings.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) => _RecommendedListingCard(listing: recommendations.listings[index]),
            ),
          ),
        ],
        if (recommendations.hospitals.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(l10n.forYouHospitals, style: Theme.of(context).textTheme.labelLarge),
          ),
          for (final hospital in recommendations.hospitals) _RecommendedHospitalTile(hospital: hospital),
        ],
      ],
    );
  }
}

/// Slim local twin of `features/marketplace/presentation/widgets/listing_card.dart`
/// - kept local rather than importing across features (Section 8.8, same
/// reasoning as [FeaturedPlace]/[_FeaturedCard] already in this file).
class _RecommendedListingCard extends StatelessWidget {
  const _RecommendedListingCard({required this.listing});

  final RecommendedListing listing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SizedBox(
      width: 170,
      child: Card(
        child: InkWell(
          onTap: () => context.push(
            listing.listingType == 'exchange' ? AppRoutes.exchange(listing.id) : AppRoutes.product(listing.id),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(aspectRatio: 4 / 3, child: RemoteImage(url: listing.imageUrl)),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(listing.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.price(listing.price, currency: listing.currency),
                      style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary),
                    ),
                    Text(
                      [Formatters.humanize(listing.condition), if (listing.isNegotiable) l10n.negotiable, listing.locationName]
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
      ),
    );
  }
}

/// Slim local twin of `features/explore/presentation/widgets/directory_tiles.dart`'s
/// `HospitalTile` - kept local for the same reason.
class _RecommendedHospitalTile extends StatelessWidget {
  const _RecommendedHospitalTile({required this.hospital});

  final RecommendedHospital hospital;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.local_hospital_outlined)),
      title: Text(hospital.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: hospital.address != null ? Text(hospital.address!, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
      onTap: () => context.push(AppRoutes.hospital(hospital.id)),
    );
  }
}
