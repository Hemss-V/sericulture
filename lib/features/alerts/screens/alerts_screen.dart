import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Alerts screen skeleton — full implementation in Phase 4.
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_rounded, size: 64, color: AppColors.statusWarning),
            SizedBox(height: 16),
            Text('Alert History', style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
            SizedBox(height: 8),
            Text('Threshold alerts coming in Phase 4',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
