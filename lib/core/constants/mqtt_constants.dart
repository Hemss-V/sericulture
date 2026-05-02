/// MQTT broker configuration constants.
///
/// Used by MqttService and SimulatorService.
/// Never hardcode these values elsewhere in the codebase.
class MqttConstants {
  MqttConstants._();

  // ── Broker connection ──────────────────────────────────────────────────────
  static const String brokerHost = 'broker.hivemq.com';
  static const int brokerPort = 1883;

  /// Prefix for the dynamically generated client ID.
  /// Full ID = clientIdPrefix + random suffix (prevents session collisions).
  static const String clientIdPrefix = 'sericulture_app_';

  // ── Subscribe topics ───────────────────────────────────────────────────────
  /// Payload: { "temp": double, "humidity": double, "co2": double, "light": double }
  static const String topicSensors = 'sericulture/field1/sensors';

  /// Payload: { "fan": bool, "heater": bool, "mister": bool, "status": String }
  static const String topicActuatorStatus = 'sericulture/field1/actuators/status';

  // ── Publish topics ─────────────────────────────────────────────────────────
  /// Payload: { "device": String, "action": String, "source": String }
  static const String topicActuatorCmd = 'sericulture/field1/actuators/cmd';

  // ── Misc ───────────────────────────────────────────────────────────────────
  /// QoS level used for all publish/subscribe operations.
  static const int qos = 1;

  /// Seconds of silence before a device is considered offline.
  static const int offlineTimeoutSeconds = 30;
}
