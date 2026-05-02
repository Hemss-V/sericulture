// lib/core/services/mqtt_service.dart
// Stub — full implementation in Phase 2
import 'dart:async';

class MqttService {
  MqttService._();
  static final MqttService instance = MqttService._();

  bool get isConnected => false;

  Future<void> connect() async {}
  Future<void> disconnect() async {}
  Future<void> publish(String topic, String payload) async {}
}
