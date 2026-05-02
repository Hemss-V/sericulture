/// All user-facing strings in one place — easy to localise later.
class AppStrings {
  AppStrings._();

  // ── App ────────────────────────────────────────────
  static const String appName = 'Sericulture IoT';
  static const String appTagline = 'Smart Silk Farm Monitor';

  // ── Auth ───────────────────────────────────────────
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String loginButton = 'Sign In';
  static const String loginError = 'Invalid email or password.';
  static const String sessionRestored = 'Welcome back!';

  // ── Navigation ─────────────────────────────────────
  static const String navDashboard = 'Dashboard';
  static const String navCharts = 'Charts';
  static const String navAlerts = 'Alerts';
  static const String navControl = 'Control';
  static const String navSettings = 'Settings';

  // ── Sensors ────────────────────────────────────────
  static const String sensorTemp = 'Temperature';
  static const String sensorHumidity = 'Humidity';
  static const String sensorCO2 = 'CO₂';
  static const String sensorLight = 'Light';

  static const String unitTemp = '°C';
  static const String unitHumidity = '%';
  static const String unitCO2 = 'ppm';
  static const String unitLight = 'lux';

  // ── Status ─────────────────────────────────────────
  static const String statusNormal = 'Normal';
  static const String statusWarning = 'Warning';
  static const String statusCritical = 'Critical';
  static const String statusOnline = 'Online';
  static const String statusOffline = 'Offline';

  // ── Actuators ──────────────────────────────────────
  static const String actuatorFan = 'Fan';
  static const String actuatorHeater = 'Heater';
  static const String actuatorMister = 'Mist Sprayer';

  // ── Actions ────────────────────────────────────────
  static const String actionOn = 'ON';
  static const String actionOff = 'OFF';
  static const String sourceManual = 'Manual';
  static const String sourceAuto = 'Auto';
  static const String sourceSchedule = 'Schedule';

  // ── Time ranges ────────────────────────────────────
  static const String range24h = '24h';
  static const String range7d = '7d';
  static const String range30d = '30d';

  // ── Alerts ─────────────────────────────────────────
  static const String alertsTitle = 'Alert History';
  static const String noAlerts = 'No alerts recorded';

  // ── Settings ───────────────────────────────────────
  static const String settingsTitle = 'Settings';
  static const String thresholds = 'Sensor Thresholds';
  static const String notifications = 'Notifications';
  static const String profile = 'Profile';
}
