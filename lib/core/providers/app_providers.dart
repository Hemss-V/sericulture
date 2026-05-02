// lib/core/providers/app_providers.dart
// Global Riverpod providers — expanded per phase.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';



final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.instance;
});
