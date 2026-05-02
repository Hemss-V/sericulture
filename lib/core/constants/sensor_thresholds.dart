/// Default sensor threshold constants.
/// These are overridable via Settings (stored in shared_preferences).
class SensorThresholds {
  SensorThresholds._();

  // ── Temperature (°C) ───────────────────────────────
  static const double tempNormalMin = 24.0;
  static const double tempNormalMax = 28.0;
  static const double tempWarningMax = 33.0;
  // > tempWarningMax → critical

  // ── Humidity (%) ───────────────────────────────────
  static const double humidityNormalMin = 70.0;
  static const double humidityNormalMax = 80.0;
  static const double humidityWarningMin = 60.0;
  // < humidityWarningMin → critical

  // ── CO2 (ppm) ──────────────────────────────────────
  static const double co2NormalMax = 1000.0;
  static const double co2WarningMax = 1500.0;
  // > co2WarningMax → critical

  // ── Light (lux) ────────────────────────────────────
  static const double lightNormalMin = 2000.0;
  static const double lightNormalMax = 4000.0;
  static const double lightWarningMin = 2000.0;  // < this → warning
  static const double lightCriticalMin = 1000.0; // < this → critical
}
