import '../../../core/models/json_helpers.dart';

/// `HospitalResponse` (+ `distance_km` for "near me").
class Hospital {
  const Hospital({
    required this.id,
    required this.locationId,
    required this.name,
    required this.type,
    this.address,
    this.contact,
    this.latitude,
    this.longitude,
    this.distanceKm,
  });

  final String id;
  final String locationId;
  final String name;

  /// `govt` | `private` | `clinic`
  final String type;
  final String? address;
  final String? contact;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json['id'] as String,
        locationId: json['location_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        type: json['type'] as String? ?? 'govt',
        address: readString(json['address']),
        contact: readString(json['contact']),
        latitude: readDouble(json['latitude']),
        longitude: readDouble(json['longitude']),
        distanceKm: readDouble(json['distance_km']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_id': locationId,
        'name': name,
        'type': type,
        'address': address,
        'contact': contact,
        'latitude': latitude,
        'longitude': longitude,
        'distance_km': distanceKm,
      };

  Hospital copyWith({String? name, String? address, String? contact, double? distanceKm}) => Hospital(
        id: id,
        locationId: locationId,
        name: name ?? this.name,
        type: type,
        address: address ?? this.address,
        contact: contact ?? this.contact,
        latitude: latitude,
        longitude: longitude,
        distanceKm: distanceKm ?? this.distanceKm,
      );
}

/// `DoctorResponse`
class Doctor {
  const Doctor({
    required this.id,
    required this.hospitalId,
    required this.name,
    this.specialty,
    this.chamberDays = const [],
    this.chamberHours,
    this.contact,
  });

  final String id;
  final String hospitalId;
  final String name;
  final String? specialty;
  final List<String> chamberDays;
  final String? chamberHours;
  final String? contact;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'] as String,
        hospitalId: json['hospital_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        specialty: readString(json['specialty']),
        chamberDays: readStringList(json['chamber_days']),
        chamberHours: readString(json['chamber_hours']),
        contact: readString(json['contact']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'hospital_id': hospitalId,
        'name': name,
        'specialty': specialty,
        'chamber_days': chamberDays,
        'chamber_hours': chamberHours,
        'contact': contact,
      };
}
