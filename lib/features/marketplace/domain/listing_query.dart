/// Query parameters shared by `GET /marketplace/products` and
/// `GET /exchange/listings`. Value-equal so it can key a Riverpod family.
class ListingQuery {
  const ListingQuery({
    this.q,
    this.categoryId,
    this.condition,
    this.sort = ListingSort.newest,
    this.minPrice,
    this.maxPrice,
    this.page = 1,
    this.pageSize = defaultPageSize,
  });

  /// Backend `DEFAULT_PAGE_SIZE` / `MAX_PAGE_SIZE`.
  static const defaultPageSize = 24;
  static const maxPageSize = 60;

  final String? q;
  final String? categoryId;
  final String? condition;
  final ListingSort sort;
  final double? minPrice;
  final double? maxPrice;
  final int page;
  final int pageSize;

  Map<String, Object?> toQueryParameters() => {
        'q': (q == null || q!.trim().isEmpty) ? null : q!.trim(),
        'category_id': categoryId,
        'condition': condition,
        'sort': sort.apiValue,
        'min_price': minPrice,
        'max_price': maxPrice,
        'page': page,
        'page_size': pageSize,
      };

  ListingQuery copyWith({
    String? q,
    String? categoryId,
    String? condition,
    ListingSort? sort,
    double? minPrice,
    double? maxPrice,
    int? page,
    int? pageSize,
  }) {
    return ListingQuery(
      q: q ?? this.q,
      categoryId: categoryId ?? this.categoryId,
      condition: condition ?? this.condition,
      sort: sort ?? this.sort,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ListingQuery &&
      other.q == q &&
      other.categoryId == categoryId &&
      other.condition == condition &&
      other.sort == sort &&
      other.minPrice == minPrice &&
      other.maxPrice == maxPrice &&
      other.page == page &&
      other.pageSize == pageSize;

  @override
  int get hashCode => Object.hash(q, categoryId, condition, sort, minPrice, maxPrice, page, pageSize);
}

enum ListingSort {
  newest('newest'),
  priceAsc('price_asc'),
  priceDesc('price_desc');

  const ListingSort(this.apiValue);

  final String apiValue;
}

/// `CategoryResponse` from `/marketplace/categories`.
class ListingCategory {
  const ListingCategory({required this.id, required this.name, required this.slug, this.parentId, this.icon, this.sortOrder = 0});

  final String id;
  final String name;
  final String slug;
  final String? parentId;
  final String? icon;
  final int sortOrder;

  factory ListingCategory.fromJson(Map<String, dynamic> json) => ListingCategory(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        parentId: json['parent_id'] as String?,
        icon: json['icon'] as String?,
        sortOrder: json['sort_order'] as int? ?? 0,
      );
}
