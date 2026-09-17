import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/offline/sync_engine.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import 'explore_providers.dart';
import 'widgets/directory_tiles.dart';
import 'widgets/near_me_bar.dart';

/// List-based directory (Section 8: "map-based, NOT 3D" — the map layer is
/// deferred until a Mapbox token exists; see [NearMeBar]).
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key, this.initialTab = ExploreTab.places});

  final ExploreTab initialTab;

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: ExploreTab.values.length,
    vsync: this,
    initialIndex: widget.initialTab.index,
  );

  @override
  void didUpdateWidget(covariant ExploreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The shell keeps this State alive, so a `?tab=` deep link / quick link
    // arrives as a widget update rather than a fresh screen.
    if (oldWidget.initialTab != widget.initialTab) {
      _tabController.animateTo(widget.initialTab.index);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Lists read the offline-synced tables reactively, so a pull only needs to
  // kick a fresh network sync - the tab views update on their own once
  // `SyncEngine` writes new data (Section: offline-first plan).
  Future<void> _refresh() async {
    ref.read(exploreRefreshTickProvider.notifier).state++;
    await ref.read(syncEngineProvider).syncAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navExplore),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: l10n.tabPlaces),
            Tab(text: l10n.tabHospitals),
            Tab(text: l10n.tabMarkets),
            Tab(text: l10n.tabBusinesses),
          ],
        ),
      ),
      body: Column(
        children: [
          const NearMeBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _DirectoryList(
                  value: ref.watch(placesProvider),
                  onRetry: _refresh,
                  itemBuilder: (place) => PlaceTile(place: place),
                ),
                _DirectoryList(
                  value: ref.watch(hospitalsProvider),
                  onRetry: _refresh,
                  itemBuilder: (hospital) => HospitalTile(hospital: hospital),
                ),
                _DirectoryList(
                  value: ref.watch(marketsProvider),
                  onRetry: _refresh,
                  itemBuilder: (market) => MarketTile(market: market),
                ),
                _DirectoryList(
                  value: ref.watch(businessesProvider),
                  onRetry: _refresh,
                  itemBuilder: (business) => BusinessTile(business: business),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectoryList<T> extends StatelessWidget {
  const _DirectoryList({required this.value, required this.onRetry, required this.itemBuilder});

  final AsyncValue<List<T>> value;
  final Future<void> Function() onRetry;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return AsyncValueWidget<List<T>>(
      value: value,
      onRetry: onRetry,
      data: (items) => RefreshIndicator(
        onRefresh: onRetry,
        child: items.isEmpty
            ? ListView(children: const [SizedBox(height: 120), EmptyState()])
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) => itemBuilder(items[index]),
              ),
      ),
    );
  }
}
