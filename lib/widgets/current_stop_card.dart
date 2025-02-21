import 'package:flutter/material.dart';
import '../models/bus_stop.dart';
import '../utils/constants.dart';

class CurrentStopCard extends StatelessWidget {
  final BusStop? currentStop;
  final BusStop? nextStop;

  const CurrentStopCard({
    super.key,
    this.currentStop,
    this.nextStop,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentStop?.name ?? 'Locating...',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                currentStop?.seq ?? '--',
                style: const TextStyle(
                  fontSize: 115,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Distance: ${currentStop?.km.toStringAsFixed(1) ?? '--'} km',
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
              ),
            ),
            if (nextStop != null) ...[
              const Divider(height: 32),
              const Text(
                'Next Stop',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                nextStop!.name,
                style: const TextStyle(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 