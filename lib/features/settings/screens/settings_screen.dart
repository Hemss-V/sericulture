import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Settings screen skeleton — thresholds & prefs wired in Phase 6.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tune_rounded, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text('Settings', style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
            SizedBox(height: 8),
            Text('Threshold config & notifications coming in Phase 6',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
