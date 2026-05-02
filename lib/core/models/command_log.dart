/// The origin of an actuator command.
enum CommandSource {
  manual,
  auto,
  schedule;

  String get label {
    switch (this) {
      case CommandSource.manual:
        return 'Manual';
      case CommandSource.auto:
        return 'Auto';
      case CommandSource.schedule:
        return 'Schedule';
    }
  }

  static CommandSource fromString(String s) {
    return CommandSource.values.firstWhere(
      (e) => e.name == s,
      orElse: () => CommandSource.manual,
    );
  }
}

/// A record of a command published to [MqttConstants.topicActuatorCmd].
///
/// Stored in a ring buffer (max 50 entries) and displayed in the
/// Control screen's command history log.
class CommandLog {
  final String id;

  /// Target device name: 'fan' | 'heater' | 'mister'
  final String device;

  /// Desired state: 'ON' | 'OFF'
  final String action;

  /// Origin of the command.
  final CommandSource source;

  final DateTime timestamp;

  const CommandLog({
    required this.id,
    required this.device,
    required this.action,
    required this.source,
    required this.timestamp,
  });

  // ── Serialisation ──────────────────────────────────────────────────────────

  factory CommandLog.fromJson(Map<String, dynamic> json) {
    return CommandLog(
      id: json['id'] as String,
      device: json['device'] as String,
      action: json['action'] as String,
      source: CommandSource.fromString(json['source'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'device': device,
        'action': action,
        'source': source.name,
        'timestamp': timestamp.toIso8601String(),
      };

  /// Builds the MQTT payload for publishing on the actuator command topic.
  Map<String, dynamic> toMqttPayload() => {
        'device': device,
        'action': action,
        'source': source.label,
      };

  // ── copyWith ───────────────────────────────────────────────────────────────

  CommandLog copyWith({
    String? id,
    String? device,
    String? action,
    CommandSource? source,
    DateTime? timestamp,
  }) {
    return CommandLog(
      id: id ?? this.id,
      device: device ?? this.device,
      action: action ?? this.action,
      source: source ?? this.source,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'CommandLog(device=$device, action=$action, source=${source.name}, ts=$timestamp)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is CommandLog && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
