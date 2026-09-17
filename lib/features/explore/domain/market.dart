import '../../../core/models/json_helpers.dart';

/// `MarketResponse` (weekly bazaar). Times arrive as `HH:MM:SS` strings.
class Market {
  const Market({
    required this.id,
    required this.locationId,
    required this.name,
    required this.type,
    this.marketDays = const [],
    this.startTime,
    this.endTime,
    this.description,
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  final String id;
  final String locationId;
  final String name;
  final List<String> marketDays;
  final String? startTime;
  final String? endTime;
  final String? description;

  /// `general` | `cattle` | `fish` | `vegetable`
  final String type;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  factory Market.fromJson(Map<String, dynamic> json) => Market(
        id: json['id'] as String,
        locationId: json['location_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        marketDays: readStringList(json['market_day']),
        startTime: readString(json['start_time']),
        endTime: readString(json['end_time']),
        description: readString(json['description']),
        type: json['type'] as String? ?? 'general',
        latitude: readDouble(json['latitude']),
        longitude: readDouble(json['longitude']),
        distanceKm: readDouble(json['distance_km']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_id': locationId,
        'name': name,
        'market_day': marketDays,
        'start_time': startTime,
        'end_time': endTime,
        'description': description,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
        'distance_km': distanceKm,
      };

  Market copyWith({String? name, List<String>? marketDays, double? distanceKm}) => Market(
        id: id,
        locationId: locationId,
        name: name ?? this.name,
        marketDays: marketDays ?? this.marketDays,
        startTime: startTime,
        endTime: endTime,
        description: description,
        type: type,
        latitude: latitude,
        longitude: longitude,
        distanceKm: distanceKm ?? this.distanceKm,
      );
}
