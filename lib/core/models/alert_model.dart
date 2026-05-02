import 'sensor_data.dart';

/// An alert generated when a sensor reading breaches a threshold.
///
/// Stored in-memory (ring buffer) and persisted to SharedPreferences as JSON
/// for the alert history screen. The [severity] reuses [SensorStatus] so the
/// UI can apply the same colour/icon logic as the sensor cards.
class AlertModel {
  final String id;
  final String sensorName;
  final double value;
  final double threshold;
  final SensorStatus severity;
  final String unit;
  final DateTime timestamp;

  /// Whether the user has acknowledged this alert (clears badge count).
  final bool isRead;

  const AlertModel({
    required this.id,
    required this.sensorName,
    required this.value,
    required this.threshold,
    required this.severity,
    required this.unit,
    required this.timestamp,
    this.isRead = false,
  });

  // ── Computed ───────────────────────────────────────────────────────────────

  /// Human-readable description suitable for a notification body or list tile.
  String get message =>
      '$sensorName breached threshold: ${value.toStringAsFixed(1)}$unit '
      '(limit: ${threshold.toStringAsFixed(1)}$unit)';

  // ── Serialisation ──────────────────────────────────────────────────────────

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as String,
      sensorName: json['sensorName'] as String,
      value: (json['value'] as num).toDouble(),
      threshold: (json['threshold'] as num).toDouble(),
      severity: SensorStatus.fromString(json['severity'] as String),
      unit: json['unit'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: (json['isRead'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sensorName': sensorName,
        'value': value,
        'threshold': threshold,
        'severity': severity.value,
        'unit': unit,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
      };

  // ── copyWith ───────────────────────────────────────────────────────────────

  AlertModel copyWith({
    String? id,
    String? sensorName,
    double? value,
    double? threshold,
    SensorStatus? severity,
    String? unit,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return AlertModel(
      id: id ?? this.id,
      sensorName: sensorName ?? this.sensorName,
      value: value ?? this.value,
      threshold: threshold ?? this.threshold,
      severity: severity ?? this.severity,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() =>
      'AlertModel(id=$id, sensor=$sensorName, value=$value, '
      'severity=${severity.name}, isRead=$isRead)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AlertModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
