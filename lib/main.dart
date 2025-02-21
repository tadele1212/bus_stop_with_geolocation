import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';
import 'screens/service_input_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: 'TKL Bus Tracking',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: const ServiceInputScreen(),
      ),
    );
  }
} 