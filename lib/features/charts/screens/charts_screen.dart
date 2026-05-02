import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Historical charts skeleton — fl_chart integration in Phase 3.
class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historical Charts')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart_rounded, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text('Historical Charts', style: TextStyle(color: AppColors.textPrimary, fontSize: 20)),
            SizedBox(height: 8),
            Text('fl_chart integration coming in Phase 3',
                style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
