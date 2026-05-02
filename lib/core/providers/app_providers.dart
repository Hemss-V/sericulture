// lib/core/providers/app_providers.dart
// Global Riverpod providers — expanded per phase.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mqtt_service.dart';
import '../services/simulator_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

/// Singleton service providers — replaced with async notifiers in Phase 2.
final mqttServiceProvider = Provider<MqttService>((ref) {
  return MqttService.instance;
});

final simulatorServiceProvider = Provider<SimulatorService>((ref) {
  return SimulatorService.instance;
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});
