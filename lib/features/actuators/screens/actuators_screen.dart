import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Actuator control screen skeleton — MQTT publish wired in Phase 5.
class ActuatorsScreen extends StatelessWidget {
  const ActuatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Control')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings_remote_rounded, size: 64, color: AppColors.accent),
            SizedBox(height: 16),
            Text('Actuator Control', style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
            SizedBox(height: 8),
            Text('Fan / Heater / Mist Sprayer toggles coming in Phase 5',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
