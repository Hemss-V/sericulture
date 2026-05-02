/// Default sensor threshold values.
///
/// These are the application defaults loaded on first run.
/// Users can override them via Settings; overridden values are persisted to
/// SharedPreferences and loaded by StorageService at startup.
///
/// Naming convention: <sensor><Level><Bound>
class ThresholdConstants {
  ThresholdConstants._();

  // ── Temperature (°C) ───────────────────────────────────────────────────────
  /// Readings above this are Warning.
  static const double tempWarning = 28.0;

  /// Readings above this are Critical (implies also above tempWarning).
  static const double tempCritical = 33.0;

  /// Normal lower bound; below this is also flagged as Warning.
  static const double tempNormalMin = 24.0;

  // ── Humidity (%) ───────────────────────────────────────────────────────────
  /// Readings below this are Warning.
  static const double humidityWarning = 70.0;

  /// Readings below this are Critical (implies also below humidityWarning).
  static const double humidityCritical = 60.0;

  /// Normal upper bound; above this is also flagged as Warning.
  static const double humidityNormalMax = 80.0;

  // ── CO₂ (ppm) ──────────────────────────────────────────────────────────────
  /// Readings above this are Warning.
  static const double co2Warning = 1000.0;

  /// Readings above this are Critical.
  static const double co2Critical = 1500.0;

  // ── Light (lux) ────────────────────────────────────────────────────────────
  /// Readings below this are Warning.
  static const double lightWarning = 2000.0;

  /// Readings below this are Critical.
  static const double lightCritical = 1000.0;

  // ── SharedPreferences keys (used by StorageService) ────────────────────────
  static const String keyTempWarning = 'threshold_temp_warning';
  static const String keyTempCritical = 'threshold_temp_critical';
  static const String keyHumidityWarning = 'threshold_humidity_warning';
  static const String keyHumidityCritical = 'threshold_humidity_critical';
  static const String keyCo2Warning = 'threshold_co2_warning';
  static const String keyCo2Critical = 'threshold_co2_critical';
  static const String keyLightWarning = 'threshold_light_warning';
  static const String keyLightCritical = 'threshold_light_critical';

  /// Returns a map of all default thresholds, keyed by the SharedPreferences keys.
  static Map<String, double> get defaults => {
        keyTempWarning: tempWarning,
        keyTempCritical: tempCritical,
        keyHumidityWarning: humidityWarning,
        keyHumidityCritical: humidityCritical,
        keyCo2Warning: co2Warning,
        keyCo2Critical: co2Critical,
        keyLightWarning: lightWarning,
        keyLightCritical: lightCritical,
      };
}
