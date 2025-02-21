import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2196F3);
  static const background = Color(0xFFF5F5F5);
  static const error = Color(0xFFE53935);
  static const cardBackground = Colors.white;
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
}

class AppConstants {
  // Database configuration
  static const String dbHost = 'my.tklcloud.com';
  static const int dbPort = 3306;
  static const String dbName = 'Bus';
  static const String dbUser = 'user1';
  static const String dbPassword = 'user1';

  // Location update interval
  static const int locationUpdateInterval = 10; // seconds
} 