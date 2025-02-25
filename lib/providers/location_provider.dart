import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  Position? _currentLocation;
  StreamSubscription<Position>? _locationSubscription;
  String? _errorMessage;

  Position? get currentLocation => _currentLocation;
  String? get errorMessage => _errorMessage;
  bool get hasLocation => _currentLocation != null;

  Future<void> initializeLocation() async {
    try {
      _errorMessage = null;
      final position = await _locationService.getCurrentLocation();
      _currentLocation = position;
      notifyListeners();

      _startLocationUpdates();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _startLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = _locationService.getLocationStream().listen(
      (Position position) {
        _currentLocation = position;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }
}
