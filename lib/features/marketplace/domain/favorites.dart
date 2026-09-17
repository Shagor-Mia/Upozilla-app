import 'exchange_listing.dart';
import 'product.dart';

/// `FavoritesResponse` — a user's saved listings across both kinds.
class Favorites {
  const Favorites({required this.exchange, required this.marketplace});

  final List<ExchangeListing> exchange;
  final List<Product> marketplace;

  bool get isEmpty => exchange.isEmpty && marketplace.isEmpty;

  factory Favorites.fromJson(Map<String, dynamic> json) => Favorites(
        exchange: (json['exchange'] as List<dynamic>? ?? const [])
            .map((e) => ExchangeListing.fromJson(e as Map<String, dynamic>))
            .toList(),
        marketplace: (json['marketplace'] as List<dynamic>? ?? const [])
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
