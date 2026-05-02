import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/mqtt_providers.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/sensor_card.dart';
import '../widgets/status_banner.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: state.isDeviceOnline
                  ? AppColors.statusNormal.withValues(alpha: 0.15)
                  : AppColors.statusCritical.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: state.isDeviceOnline ? AppColors.statusNormal : AppColors.statusCritical,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: state.isDeviceOnline ? AppColors.statusNormal : AppColors.statusCritical,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  state.isDeviceOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: state.isDeviceOnline ? AppColors.statusNormal : AppColors.statusCritical,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(mqttServiceProvider.notifier).connect();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            StatusBanner(
              alerts: state.activeAlerts,
              hasCritical: state.hasCriticalAlert,
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Live Sensor Data',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    state.latestData == null 
                        ? 'Waiting for data...' 
                        : 'Updated: ${state.secondsSinceLastUpdate}s ago',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.05, 
                children: [
                  SensorCard(
                    title: 'Temperature',
                    icon: Icons.thermostat,
                    value: state.latestData?.temperature,
                    unit: '°C',
                    status: state.latestData?.temperatureStatus,
                  ),
                  SensorCard(
                    title: 'Humidity',
                    icon: Icons.water_drop,
                    value: state.latestData?.humidity,
                    unit: '%',
                    status: state.latestData?.humidityStatus,
                  ),
                  SensorCard(
                    title: 'CO₂',
                    icon: Icons.air,
                    value: state.latestData?.co2,
                    unit: 'ppm',
                    status: state.latestData?.co2Status,
                  ),
                  SensorCard(
                    title: 'Light',
                    icon: Icons.light_mode,
                    value: state.latestData?.light,
                    unit: 'lux',
                    status: state.latestData?.lightStatus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
