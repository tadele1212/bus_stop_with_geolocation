import 'package:flutter/material.dart';
import '../utils/constants.dart';

class LoadingSpinner extends StatelessWidget {
  final String? message;
  final double size;

  const LoadingSpinner({
    super.key,
    this.message,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: size * 0.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
} 