/// MQTT broker configuration and topic constants.
class MqttTopics {
  MqttTopics._();

  // ── Broker ─────────────────────────────────────────
  static const String brokerHost = 'broker.hivemq.com';
  static const int brokerPort = 1883;
  static const String clientIdPrefix = 'sericulture_app_';

  // ── Subscribe topics ───────────────────────────────
  static const String sensors = 'sericulture/field1/sensors';
  static const String actuatorsStatus = 'sericulture/field1/actuators/status';

  // ── Publish topics ─────────────────────────────────
  static const String actuatorsCmd = 'sericulture/field1/actuators/cmd';
}
