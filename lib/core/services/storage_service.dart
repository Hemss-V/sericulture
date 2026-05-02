import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/threshold_constants.dart';

/// Persistent storage layer using SharedPreferences.
///
/// All keys are private constants to avoid magic strings across the codebase.
/// Call [init] once at app startup before using any other method.
///
/// Methods are intentionally synchronous-looking (async/await hidden inside)
/// so call sites stay clean.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late SharedPreferences _prefs;
  bool _initialised = false;

  // ── Private keys ───────────────────────────────────────────────────────────

  static const String _keyUserEmail = 'session_user_email';
  static const String _keyThresholds = 'thresholds_map';
  static const String _keyNotifPrefs = 'notif_prefs_map';

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  /// Must be called once in [main] before [runApp].
  Future<void> init() async {
    if (_initialised) return;
    _prefs = await SharedPreferences.getInstance();
    await _seedDefaultsIfNeeded();
    _initialised = true;
  }

  /// Seeds threshold and notification defaults on first run.
  Future<void> _seedDefaultsIfNeeded() async {
    if (!_prefs.containsKey(_keyThresholds)) {
      final defaults = <String, double>{...ThresholdConstants.defaults};
      await _prefs.setString(_keyThresholds, jsonEncode(defaults));
    }
    if (!_prefs.containsKey(_keyNotifPrefs)) {
      await _prefs.setString(
        _keyNotifPrefs,
        jsonEncode(_defaultNotifPrefs()),
      );
    }
  }

  // ── User session ───────────────────────────────────────────────────────────

  /// Persists the logged-in user's email. Pass [null] to clear.
  Future<void> saveUser(String email) async {
    await _prefs.setString(_keyUserEmail, email);
  }

  /// Returns the stored email, or [null] if no session exists.
  String? getUser() => _prefs.getString(_keyUserEmail);

  /// Clears the stored session (called on logout).
  Future<void> clearUser() async {
    await _prefs.remove(_keyUserEmail);
  }

  // ── Thresholds ─────────────────────────────────────────────────────────────

  /// Persists a map of threshold overrides.
  ///
  /// Map must be keyed by [ThresholdConstants.key*] constants.
  /// Example:
  /// ```dart
  /// await StorageService.instance.saveThresholds({
  ///   ThresholdConstants.keyTempWarning: 30.0,
  ///   ThresholdConstants.keyTempCritical: 35.0,
  /// });
  /// ```
  Future<void> saveThresholds(Map<String, double> thresholds) async {
    final merged = <String, double>{
      ...loadThresholds(),
      ...thresholds,
    };
    await _prefs.setString(_keyThresholds, jsonEncode(merged));
  }

  /// Returns the full threshold map, falling back to defaults for missing keys.
  Map<String, double> loadThresholds() {
    final raw = _prefs.getString(_keyThresholds);
    if (raw == null) return Map.from(ThresholdConstants.defaults);
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final result = <String, double>{...ThresholdConstants.defaults};
      decoded.forEach((k, v) {
        if (v is num) result[k] = v.toDouble();
      });
      return result;
    } catch (_) {
      return Map.from(ThresholdConstants.defaults);
    }
  }

  /// Resets all thresholds to factory defaults.
  Future<void> resetThresholds() async {
    await _prefs.setString(
      _keyThresholds,
      jsonEncode(ThresholdConstants.defaults),
    );
  }

  // ── Notification preferences ───────────────────────────────────────────────

  /// Persists notification enable/disable state for individual sensors.
  ///
  /// Map keys: 'temperature' | 'humidity' | 'co2' | 'light' — values: bool.
  Future<void> saveNotifPrefs(Map<String, bool> prefs) async {
    final merged = <String, bool>{
      ..._parseNotifPrefs(_prefs.getString(_keyNotifPrefs)),
      ...prefs,
    };
    await _prefs.setString(_keyNotifPrefs, jsonEncode(merged));
  }

  /// Returns the notification preference map. All sensors default to enabled.
  Map<String, bool> loadNotifPrefs() {
    return _parseNotifPrefs(_prefs.getString(_keyNotifPrefs));
  }

  /// Returns whether notifications are enabled for a specific [sensorKey].
  bool isNotifEnabled(String sensorKey) {
    return loadNotifPrefs()[sensorKey] ?? true;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  static Map<String, bool> _defaultNotifPrefs() => {
        'temperature': true,
        'humidity': true,
        'co2': true,
        'light': true,
      };

  static Map<String, bool> _parseNotifPrefs(String? raw) {
    if (raw == null) return _defaultNotifPrefs();
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as bool));
    } catch (_) {
      return _defaultNotifPrefs();
    }
  }

  // ── Debug / test helpers ───────────────────────────────────────────────────

  /// Wipes all stored data. Intended for testing and logout flows.
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
