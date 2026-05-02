import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/sensor_data.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double? value;
  final String unit;
  final SensorStatus? status;

  const SensorCard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.unit,
    this.status,
  });

  Color _getStatusColor() {
    if (status == null) return AppColors.textSecondary;
    switch (status!) {
      case SensorStatus.normal:
        return const Color(0xFF10B981); // green
      case SensorStatus.warning:
        return const Color(0xFFF59E0B); // amber
      case SensorStatus.critical:
        return const Color(0xFFEF4444); // red
    }
  }

  Color _getBgTint() {
    if (status == null) return AppColors.surface;
    switch (status!) {
      case SensorStatus.normal:
        return AppColors.surface;
      case SensorStatus.warning:
        return const Color(0xFFF59E0B).withValues(alpha: 0.05);
      case SensorStatus.critical:
        return const Color(0xFFEF4444).withValues(alpha: 0.05);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final bgTint = _getBgTint();

    return Container(
      decoration: BoxDecoration(
        color: bgTint,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: status == SensorStatus.critical || status == SensorStatus.warning
              ? statusColor.withValues(alpha: 0.3)
              : AppColors.surfaceVariant,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              if (status != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Text(
                    status!.label,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (value == null)
            const SizedBox(
              height: 32,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TweenAnimationBuilder<double>(
              key: ValueKey(value),
              duration: const Duration(milliseconds: 300),
              tween: Tween<double>(begin: 0.8, end: 1.0),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        value!.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
