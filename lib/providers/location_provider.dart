import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  Position? _currentLocation;
  StreamSubscription<Position>? _locationSubscription;
  String? _errorMessage;
  bool _isActive = false;
  Timer? _watchdogTimer;

  Position? get currentLocation => _currentLocation;
  String? get errorMessage => _errorMessage;
  bool get hasLocation => _currentLocation != null;
  bool get isActive => _isActive;

  Future<void> initializeLocation() async {
    try {
      _errorMessage = null;
      final position = await _locationService.getCurrentLocation();
      _currentLocation = position;
      notifyListeners();

      _startLocationUpdates();
      _startWatchdog();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _startWatchdog() {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_isActive && _locationSubscription == null) {
        print('LocationProvider: Watchdog detected dead stream, restarting...');
        _startLocationUpdates();
      }
    });
  }

  void _startLocationUpdates() {
    try {
      _locationSubscription?.cancel();
      _isActive = true;

      _locationSubscription = _locationService.getLocationStream().listen(
        (Position position) {
          print('LocationProvider: Received location update');
          _currentLocation = position;
          _errorMessage = null;
          notifyListeners();
        },
        onError: (error) {
          print('LocationProvider: Stream error - $error');
          _errorMessage = error.toString();
          _restartLocationUpdates();
          notifyListeners();
        },
        onDone: () {
          print('LocationProvider: Stream closed, attempting restart');
          _restartLocationUpdates();
        },
      );
    } catch (e) {
      print('LocationProvider: Failed to start updates - $e');
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void _restartLocationUpdates() {
    if (!_isActive) return;

    Future.delayed(const Duration(seconds: 1), () {
      print('LocationProvider: Attempting to restart location updates');
      _startLocationUpdates();
    });
  }

  void stopLocationUpdates() {
    _isActive = false;
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }
}
