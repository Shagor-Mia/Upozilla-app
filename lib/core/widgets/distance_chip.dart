import 'package:flutter/material.dart';

import '../utils/formatters.dart';

/// Shows `distance_km` returned by the "near me" endpoints; renders nothing
/// when the value is absent so list tiles can include it unconditionally.
class DistanceChip extends StatelessWidget {
  const DistanceChip({super.key, required this.distanceKm});

  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    final km = distanceKm;
    if (km == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.near_me_rounded, size: 14, color: scheme.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            Formatters.distanceKm(km),
            style: TextStyle(fontSize: 12, color: scheme.onSecondaryContainer),
          ),
        ],
      ),
    );
  }
}
