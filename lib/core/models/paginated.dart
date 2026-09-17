/// Mirrors the backend `Paginated[T]` envelope: `{items, total, page, page_size}`.
class Paginated<T> {
  const Paginated({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<T> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => page * pageSize < total;

  factory Paginated.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) itemFromJson,
  ) {
    final rawItems = json['items'] as List<dynamic>? ?? const [];
    return Paginated<T>(
      items: rawItems.map((e) => itemFromJson(e as Map<String, dynamic>)).toList(),
      total: json['total'] as int? ?? rawItems.length,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? rawItems.length,
    );
  }
}
