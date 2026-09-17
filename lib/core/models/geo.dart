import 'dart:math' as math;

class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) =>
      other is GeoPoint && other.latitude == latitude && other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

/// "Near me" filter for the directory list endpoints (Phase 3):
/// `?lat=&lng=&radius_km=` — backend default radius 10 km, max 50 km.
class NearMeQuery {
  const NearMeQuery({required this.center, this.radiusKm = defaultRadiusKm});

  static const double defaultRadiusKm = 10;
  static const double maxRadiusKm = 50;

  final GeoPoint center;
  final double radiusKm;

  Map<String, Object?> toQueryParameters() => {
        'lat': center.latitude,
        'lng': center.longitude,
        'radius_km': radiusKm,
      };

  @override
  bool operator ==(Object other) =>
      other is NearMeQuery && other.center == center && other.radiusKm == radiusKm;

  @override
  int get hashCode => Object.hash(center, radiusKm);
}

/// Great-circle distance in kilometres. Used to do "near me" filtering
/// locally against the offline-synced directory tables instead of relying on
/// the backend's `lat/lng/radius_km` query, so near-me works with no network.
double haversineKm(GeoPoint a, GeoPoint b) {
  const earthRadiusKm = 6371.0;
  final dLat = _degToRad(b.latitude - a.latitude);
  final dLng = _degToRad(b.longitude - a.longitude);
  final lat1 = _degToRad(a.latitude);
  final lat2 = _degToRad(b.latitude);
  final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.sin(dLng / 2) * math.sin(dLng / 2) * math.cos(lat1) * math.cos(lat2);
  return earthRadiusKm * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
}

double _degToRad(double deg) => deg * math.pi / 180;
