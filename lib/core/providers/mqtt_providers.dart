import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mqtt_service.dart';
import '../services/simulator_service.dart';
import '../models/sensor_data.dart';
import '../models/actuator_status.dart';

/// Singleton MqttService provider (StateNotifier tracking connection state).
final mqttServiceProvider = StateNotifierProvider<MqttService, String>((ref) {
  return MqttService(ref);
});

/// Singleton SimulatorService provider.
final simulatorServiceProvider = Provider<SimulatorService>((ref) {
  return SimulatorService();
});

/// Stream of incoming sensor readings.
final sensorDataProvider = StreamProvider<SensorData>((ref) {
  return ref.watch(mqttServiceProvider.notifier).sensorStream;
});

/// Stream of incoming actuator status updates.
final actuatorStatusProvider = StreamProvider<ActuatorStatus>((ref) {
  return ref.watch(mqttServiceProvider.notifier).actuatorStream;
});

/// Holds the most recently received SensorData.
final latestSensorProvider = StateProvider<SensorData?>((ref) => null);

/// Holds the most recently received ActuatorStatus.
final latestActuatorProvider = StateProvider<ActuatorStatus?>((ref) => null);

/// Exposes just the connection state string ('disconnected', 'connecting', 'connected', 'error').
final mqttConnectionStateProvider = Provider<String>((ref) {
  return ref.watch(mqttServiceProvider);
});
