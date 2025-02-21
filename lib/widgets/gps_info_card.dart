import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:geolocator/geolocator.dart';

class GPSInfoCard extends StatelessWidget {
  final Position? currentLocation;

  const GPSInfoCard({
    super.key,
    this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'GPS Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Latitude: ${currentLocation?.latitude.toStringAsFixed(6) ?? '--'}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Longitude: ${currentLocation?.longitude.toStringAsFixed(6) ?? '--'}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 