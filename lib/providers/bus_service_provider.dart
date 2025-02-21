import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/bus_stop.dart';
import '../services/database_service.dart';

class BusServiceProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final String serviceNo;
  
  List<BusStop> _stops = [];
  BusStop? _currentStop;
  BusStop? _nextStop;
  String? _errorMessage;
  bool _isLoading = false;

  BusServiceProvider(this.serviceNo) {
    _initializeService();
  }

  List<BusStop> get stops => _stops;
  BusStop? get currentStop => _currentStop;
  BusStop? get nextStop => _nextStop;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> _initializeService() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _databaseService.getServiceDetails(serviceNo);
      if (response.success) {
        _stops = response.data ?? [];
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = 'Failed to load service details: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLocation(Position position) async {
    print('BusServiceProvider: Updating location - lat: ${position.latitude}, lng: ${position.longitude}');
    try {
      final response = await _databaseService.getNearestStop(
        position.latitude,
        position.longitude,
        serviceNo,
        _currentStop?.name ?? '',
      );

      if (response.success && response.data != null) {
        print('BusServiceProvider: Setting current stop to ${response.data?.name}');
        _currentStop = response.data;
        _updateNextStop();
        print('BusServiceProvider: Next stop will be ${_nextStop?.name}');
        notifyListeners();
      } else {
        print('BusServiceProvider: No stop found or error - ${response.message}');
      }
    } catch (e) {
      print('BusServiceProvider ERROR: $e');
      _errorMessage = 'Failed to update location: $e';
      notifyListeners();
    }
  }

  void _updateNextStop() {
    if (_currentStop == null || _stops.isEmpty) return;
    
    final currentIndex = _stops.indexWhere((stop) => stop.seq == _currentStop!.seq);
    if (currentIndex != -1 && currentIndex < _stops.length - 1) {
      _nextStop = _stops[currentIndex + 1];
    } else {
      _nextStop = null;
    }
  }

  Future<void> refresh() async {
    await _initializeService();
  }
} 