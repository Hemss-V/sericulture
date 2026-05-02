/// Live status of the three actuator devices.
///
/// Received from MQTT topic [MqttConstants.topicActuatorStatus].
/// All fields are immutable. Use [copyWith] to toggle individual devices.
class ActuatorStatus {
  final bool fan;
  final bool heater;
  final bool mister;

  /// Connection status reported by the hardware (e.g. "online", "offline").
  final String status;

  final DateTime timestamp;

  const ActuatorStatus({
    required this.fan,
    required this.heater,
    required this.mister,
    required this.status,
    required this.timestamp,
  });

  // ── Named constructors ─────────────────────────────────────────────────────

  factory ActuatorStatus.initial() => ActuatorStatus(
        fan: false,
        heater: false,
        mister: false,
        status: 'offline',
        timestamp: DateTime.now(),
      );

  // ── Serialisation ──────────────────────────────────────────────────────────

  factory ActuatorStatus.fromJson(Map<String, dynamic> json) {
    return ActuatorStatus(
      fan: _parseBool(json['fan']),
      heater: _parseBool(json['heater']),
      mister: _parseBool(json['mister']),
      status: (json['status'] as String?) ?? 'online',
      timestamp: json.containsKey('timestamp')
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'fan': fan,
        'heater': heater,
        'mister': mister,
        'status': status,
        'timestamp': timestamp.toIso8601String(),
      };

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool get isOnline => status == 'online';

  /// Returns the current state of a device by name ('fan'|'heater'|'mister').
  bool stateFor(String device) {
    switch (device.toLowerCase()) {
      case 'fan':
        return fan;
      case 'heater':
        return heater;
      case 'mister':
        return mister;
      default:
        return false;
    }
  }

  // ── copyWith ───────────────────────────────────────────────────────────────

  ActuatorStatus copyWith({
    bool? fan,
    bool? heater,
    bool? mister,
    String? status,
    DateTime? timestamp,
  }) {
    return ActuatorStatus(
      fan: fan ?? this.fan,
      heater: heater ?? this.heater,
      mister: mister ?? this.mister,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'ActuatorStatus(fan=$fan, heater=$heater, mister=$mister, status=$status)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActuatorStatus &&
          fan == other.fan &&
          heater == other.heater &&
          mister == other.mister &&
          status == other.status &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(fan, heater, mister, status, timestamp);

  // ── Private ────────────────────────────────────────────────────────────────

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }
}
