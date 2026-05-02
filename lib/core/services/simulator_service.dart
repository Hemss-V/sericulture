// lib/core/services/simulator_service.dart
// Stub — full implementation in Phase 2

/// MqttSimulator publishes realistic sensor readings every 5 seconds.
/// Full implementation (sinusoidal + noise generation) added in Phase 2.
class SimulatorService {
  SimulatorService._();
  static final SimulatorService instance = SimulatorService._();

  bool _running = false;
  bool get isRunning => _running;

  void start() { _running = true; }
  void stop() { _running = false; }
}
