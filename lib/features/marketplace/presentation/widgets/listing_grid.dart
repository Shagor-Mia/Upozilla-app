import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/paged_items.dart';

/// Infinite-scroll grid over a [PagedItems] state; calls [onLoadMore] when
/// the user nears the end and [onRefresh] on pull-to-refresh / retry.
class ListingGrid<T> extends ConsumerStatefulWidget {
  const ListingGrid({
    super.key,
    required this.value,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.onRefresh,
  });

  final AsyncValue<PagedItems<T>> value;
  final Widget Function(T item) itemBuilder;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  @override
  ConsumerState<ListingGrid<T>> createState() => _ListingGridState<T>();
}

class _ListingGridState<T> extends ConsumerState<ListingGrid<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_maybeLoadMore);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeLoadMore() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AsyncValueWidget<PagedItems<T>>(
      value: widget.value,
      onRetry: widget.onRefresh,
      data: (paged) {
        if (paged.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: ListView(children: [const SizedBox(height: 120), EmptyState(title: l10n.noResults)]),
          );
        }
        return RefreshIndicator(
          onRefresh: widget.onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(12),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => widget.itemBuilder(paged.items[index]),
                    childCount: paged.items.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: paged.isLoadingMore
                    ? const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
                    : paged.hasMore
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: TextButton(onPressed: widget.onLoadMore, child: Text(l10n.loadMore)),
                            ),
                          )
                        : const SizedBox(height: 24),
              ),
            ],
          ),
        );
      },
    );
  }
}
