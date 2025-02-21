import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bus_service_provider.dart';
import '../providers/location_provider.dart';
import '../widgets/current_stop_card.dart';
import '../widgets/stops_table_modal.dart';
import '../utils/constants.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/gps_info_card.dart';

class RealtimeTrackingScreen extends StatefulWidget {
  final String serviceNo;

  const RealtimeTrackingScreen({
    super.key,
    required this.serviceNo,
  });

  @override
  State<RealtimeTrackingScreen> createState() => _RealtimeTrackingScreenState();
}

class _RealtimeTrackingScreenState extends State<RealtimeTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusServiceProvider(widget.serviceNo),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Service ${widget.serviceNo}'),
          actions: [
            Consumer<BusServiceProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: provider.isLoading ? null : provider.refresh,
                );
              },
            ),
          ],
        ),
        body: Consumer2<LocationProvider, BusServiceProvider>(
          builder: (context, locationProvider, busProvider, child) {
            print(
                'RealtimeTracking: Got location update - ${locationProvider.currentLocation?.latitude}, ${locationProvider.currentLocation?.longitude}');

            if (locationProvider.currentLocation != null) {
              print(
                  'RealtimeTracking: Updating bus provider with new location');
              busProvider.updateLocation(locationProvider.currentLocation!);
            }

            if (busProvider.isLoading) {
              print('RealtimeTracking: Bus provider is loading');
              return const LoadingSpinner(
                message: 'Loading bus service details...',
              );
            }

            if (busProvider.errorMessage != null) {
              print('RealtimeTracking ERROR: ${busProvider.errorMessage}');
              return Center(
                child: Text(
                  busProvider.errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              );
            }

            print(
                'RealtimeTracking: Displaying current stop: ${busProvider.currentStop?.name}, next stop: ${busProvider.nextStop?.name}');
            print(
                'RealtimeTracking: Current location: ${locationProvider.currentLocation?.latitude}, ${locationProvider.currentLocation?.longitude}');
            return Column(
              children: [
                GPSInfoCard(
                  currentLocation: locationProvider.currentLocation,
                ),
                CurrentStopCard(
                  currentStop: busProvider.currentStop,
                  nextStop: busProvider.nextStop,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => StopsTableModal(
                          stops: busProvider.stops,
                          currentStop: busProvider.currentStop,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('View All Stops'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
