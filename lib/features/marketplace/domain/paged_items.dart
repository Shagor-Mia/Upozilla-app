import '../../../core/models/paginated.dart';

/// Accumulated pages for an infinite-scroll list.
class PagedItems<T> {
  const PagedItems({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    this.isLoadingMore = false,
  });

  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final bool isLoadingMore;

  bool get hasMore => items.length < total;

  factory PagedItems.fromPage(Paginated<T> first) => PagedItems<T>(
        items: first.items,
        total: first.total,
        page: first.page,
        pageSize: first.pageSize,
      );

  PagedItems<T> append(Paginated<T> next) => PagedItems<T>(
        items: [...items, ...next.items],
        total: next.total,
        page: next.page,
        pageSize: next.pageSize,
      );

  PagedItems<T> copyWith({bool? isLoadingMore}) => PagedItems<T>(
        items: items,
        total: total,
        page: page,
        pageSize: pageSize,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}
