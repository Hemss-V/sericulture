import '../constants/threshold_constants.dart';

/// Severity level of a sensor reading relative to its configured thresholds.
enum SensorStatus {
  normal,
  warning,
  critical;

  String get label {
    switch (this) {
      case SensorStatus.normal:
        return 'Normal';
      case SensorStatus.warning:
        return 'Warning';
      case SensorStatus.critical:
        return 'Critical';
    }
  }

  /// JSON-safe string representation.
  String get value => name; // 'normal' | 'warning' | 'critical'

  static SensorStatus fromString(String s) {
    return SensorStatus.values.firstWhere(
      (e) => e.name == s,
      orElse: () => SensorStatus.normal,
    );
  }
}

/// A single sensor reading snapshot received from MQTT or the simulator.
///
/// All fields are immutable. Use [copyWith] to produce updated snapshots.
/// Status getters evaluate against the default [ThresholdConstants]; the UI
/// layer can pass overridden thresholds as parameters when needed.
class SensorData {
  final double temperature;
  final double humidity;
  final double co2;
  final double light;
  final DateTime timestamp;

  const SensorData({
    required this.temperature,
    required this.humidity,
    required this.co2,
    required this.light,
    required this.timestamp,
  });

  // ── Serialisation ──────────────────────────────────────────────────────────

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: (json['temp'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      co2: (json['co2'] as num).toDouble(),
      light: (json['light'] as num).toDouble(),
      timestamp: json.containsKey('timestamp')
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'temp': temperature,
        'humidity': humidity,
        'co2': co2,
        'light': light,
        'timestamp': timestamp.toIso8601String(),
      };

  // ── Status helpers (default thresholds) ───────────────────────────────────

  SensorStatus get temperatureStatus {
    if (temperature > ThresholdConstants.tempCritical) return SensorStatus.critical;
    if (temperature > ThresholdConstants.tempWarning) return SensorStatus.warning;
    if (temperature < ThresholdConstants.tempNormalMin) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  SensorStatus get humidityStatus {
    if (humidity < ThresholdConstants.humidityCritical) return SensorStatus.critical;
    if (humidity < ThresholdConstants.humidityWarning) return SensorStatus.warning;
    if (humidity > ThresholdConstants.humidityNormalMax) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  SensorStatus get co2Status {
    if (co2 > ThresholdConstants.co2Critical) return SensorStatus.critical;
    if (co2 > ThresholdConstants.co2Warning) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  SensorStatus get lightStatus {
    if (light < ThresholdConstants.lightCritical) return SensorStatus.critical;
    if (light < ThresholdConstants.lightWarning) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  /// Overall worst-case status across all four sensors.
  SensorStatus get overallStatus {
    final all = [temperatureStatus, humidityStatus, co2Status, lightStatus];
    if (all.any((s) => s == SensorStatus.critical)) return SensorStatus.critical;
    if (all.any((s) => s == SensorStatus.warning)) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  // ── Status helpers (custom thresholds) ────────────────────────────────────
  // These overloads are used by the dashboard when users have saved custom
  // thresholds via Settings.

  SensorStatus temperatureStatusWith({
    required double warning,
    required double critical,
    required double normalMin,
  }) {
    if (temperature > critical) return SensorStatus.critical;
    if (temperature > warning) return SensorStatus.warning;
    if (temperature < normalMin) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  SensorStatus humidityStatusWith({
    required double warning,
    required double critical,
    required double normalMax,
  }) {
    if (humidity < critical) return SensorStatus.critical;
    if (humidity < warning) return SensorStatus.warning;
    if (humidity > normalMax) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  SensorStatus co2StatusWith({
    required double warning,
    required double critical,
  }) {
    if (co2 > critical) return SensorStatus.critical;
    if (co2 > warning) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  SensorStatus lightStatusWith({
    required double warning,
    required double critical,
  }) {
    if (light < critical) return SensorStatus.critical;
    if (light < warning) return SensorStatus.warning;
    return SensorStatus.normal;
  }

  // ── copyWith ───────────────────────────────────────────────────────────────

  SensorData copyWith({
    double? temperature,
    double? humidity,
    double? co2,
    double? light,
    DateTime? timestamp,
  }) {
    return SensorData(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      co2: co2 ?? this.co2,
      light: light ?? this.light,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'SensorData(temp=$temperature, humidity=$humidity, co2=$co2, '
      'light=$light, ts=$timestamp)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorData &&
          temperature == other.temperature &&
          humidity == other.humidity &&
          co2 == other.co2 &&
          light == other.light &&
          timestamp == other.timestamp;

  @override
  int get hashCode =>
      Object.hash(temperature, humidity, co2, light, timestamp);
}
