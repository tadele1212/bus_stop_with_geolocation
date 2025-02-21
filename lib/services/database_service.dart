import 'package:mysql1/mysql1.dart';
import '../models/bus_stop.dart';
import '../models/service_response.dart';
import '../utils/constants.dart';

class DatabaseService {
  MySqlConnection? _connection;
  
  Future<void> ensureConnection() async {
    try {
      if (_connection == null) {
        print('DatabaseService: Connection is null, connecting...');
        await connect();
        return;
      }

      // Test connection with a simple query
      try {
        await _connection!.query('SELECT 1');
      } catch (e) {
        print('DatabaseService: Connection test failed, reconnecting...');
        await _connection?.close();
        _connection = null;
        await connect();
      }
    } catch (e) {
      print('DatabaseService: Connection error, attempting reconnect: $e');
      await connect();
    }
  }

  Future<void> connect() async {
    try {
      final settings = ConnectionSettings(
        host: AppConstants.dbHost,
        port: AppConstants.dbPort,
        user: AppConstants.dbUser,
        password: AppConstants.dbPassword,
        db: AppConstants.dbName,
      );
      
      _connection = await MySqlConnection.connect(settings);
      print('DatabaseService: Successfully connected to database');
    } catch (e) {
      print('DatabaseService: Failed to connect to database: $e');
      throw Exception('Failed to connect to database: $e');
    }
  }

  Future<ServiceResponse<List<BusStop>>> getServiceDetails(String serviceNo) async {
    try {
      await ensureConnection();  // Check connection before query

      final results = await _connection!.query(
        'CALL Show_Stop(?)',
        [serviceNo],
      );

      final stops = results.map((row) => BusStop.fromMap({
        'seq': row['Seq'],
        'name': row['Bus Stop'],
        'km': row['KM'],
      })).toList();

      return ServiceResponse.success(stops);
    } catch (e) {
      print('DatabaseService: Error getting service details: $e');
      return ServiceResponse.error(e);
    }
  }

  Future<ServiceResponse<BusStop?>> getNearestStop(
    double lat, 
    double lng, 
    String serviceNo, 
    String lastStop
  ) async {
    try {
      await ensureConnection();  // Check connection before query
      print('DatabaseService: Getting nearest stop - lat: $lat, lng: $lng, service: $serviceNo');

      final results = await _connection!.query(
        'CALL Nearest_stop(?, ?, ?, ?)',
        [serviceNo, lat, lng, lastStop],
      );

      print('Raw database results: $results');
      if (results.isEmpty) {
        print('DatabaseService: No stops found');
        return ServiceResponse.success(null, 'No nearby stops found');
      }

      final row = results.first;
      print('Raw row data: $row');

      final stop = BusStop.fromMap({
        'seq': row['Seq'],
        'name': row['Bus Stop'],
        'km': row['KM'],
      });
      
      print('DatabaseService: Found nearest stop - ${stop.name}');
      return ServiceResponse.success(stop);
    } catch (e) {
      print('DatabaseService: Error getting nearest stop: $e');
      return ServiceResponse.error(e);
    }
  }

  Future<void> dispose() async {
    try {
      await _connection?.close();
      _connection = null;
      print('DatabaseService: Connection closed');
    } catch (e) {
      print('DatabaseService: Error closing connection: $e');
    }
  }
} 