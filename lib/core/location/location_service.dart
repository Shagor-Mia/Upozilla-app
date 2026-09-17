import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../error/app_exception.dart';
import '../models/geo.dart';

/// Wraps geolocator so features depend on a small, mockable surface and
/// receive typed [LocationException]s instead of platform exceptions.
class LocationService {
  const LocationService();

  static const _timeLimit = Duration(seconds: 15);

  Future<GeoPoint> currentPosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException(
        'Turn on location services to find things near you',
        reason: LocationFailureReason.serviceDisabled,
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission is blocked; enable it in system settings',
        reason: LocationFailureReason.permissionDeniedForever,
      );
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(
        'Location permission is required for "near me"',
        reason: LocationFailureReason.permissionDenied,
      );
    }

    final position = await _firstFix();
    if (position == null) {
      throw const LocationException(
        'Could not determine your location',
        reason: LocationFailureReason.unavailable,
      );
    }
    return GeoPoint(latitude: position.latitude, longitude: position.longitude);
  }

  /// Tries the platform's fused provider first (best on phones with Google
  /// Play services), then Android's raw LocationManager (devices without GMS,
  /// and emulators fed via `adb emu geo fix`), then the last known position.
  /// A km-scale "near me" radius does not need a fresh high-accuracy fix.
  Future<Position?> _firstFix() async {
    final attempts = <Future<Position?> Function()>[
      () => Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: _timeLimit,
            ),
          ),
      if (!kIsWeb && Platform.isAndroid)
        () => Geolocator.getCurrentPosition(
              locationSettings: AndroidSettings(
                accuracy: LocationAccuracy.high,
                timeLimit: _timeLimit,
                forceLocationManager: true,
              ),
            ),
      Geolocator.getLastKnownPosition,
    ];
    for (final attempt in attempts) {
      try {
        final position = await attempt();
        if (position != null) return position;
      } on Exception {
        // Fall through to the next strategy.
      }
    }
    return null;
  }
}

final locationServiceProvider = Provider<LocationService>((ref) => const LocationService());
