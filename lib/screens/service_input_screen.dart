import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/location_provider.dart';
import '../utils/constants.dart';
import 'realtime_tracking_screen.dart';

class ServiceInputScreen extends StatefulWidget {
  const ServiceInputScreen({super.key});

  @override
  State<ServiceInputScreen> createState() => _ServiceInputScreenState();
}

class _ServiceInputScreenState extends State<ServiceInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLastService();
  }

  Future<void> _loadLastService() async {
    final prefs = await SharedPreferences.getInstance();
    final lastService = prefs.getString('last_service');
    if (lastService != null) {
      _serviceController.text = lastService;
    }
  }

  Future<void> _saveService(String service) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_service', service);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Initialize location before proceeding
      await context.read<LocationProvider>().initializeLocation();
      
      if (!mounted) return;

      // Save the service number
      await _saveService(_serviceController.text);

      // Changed from pushReplacement to push
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RealtimeTrackingScreen(
            serviceNo: _serviceController.text,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Enter Bus Service Number',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _serviceController,
                  decoration: InputDecoration(
                    labelText: 'Service Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a service number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Start Tracking'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _serviceController.dispose();
    super.dispose();
  }
} 