import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/sensor_data.dart';
import '../../../core/providers/mqtt_providers.dart';

class DashboardState {
  final bool isDeviceOnline;
  final int secondsSinceLastUpdate;
  final List<String> activeAlerts;
  final bool hasCriticalAlert;
  final SensorData? latestData;

  const DashboardState({
    required this.isDeviceOnline,
    required this.secondsSinceLastUpdate,
    required this.activeAlerts,
    required this.hasCriticalAlert,
    required this.latestData,
  });

  DashboardState copyWith({
    bool? isDeviceOnline,
    int? secondsSinceLastUpdate,
    List<String>? activeAlerts,
    bool? hasCriticalAlert,
    SensorData? latestData,
  }) {
    return DashboardState(
      isDeviceOnline: isDeviceOnline ?? this.isDeviceOnline,
      secondsSinceLastUpdate: secondsSinceLastUpdate ?? this.secondsSinceLastUpdate,
      activeAlerts: activeAlerts ?? this.activeAlerts,
      hasCriticalAlert: hasCriticalAlert ?? this.hasCriticalAlert,
      latestData: latestData ?? this.latestData,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final Ref ref;
  Timer? _timer;
  DateTime? _lastReceivedLocalTime;

  DashboardNotifier(this.ref)
      : super(const DashboardState(
          isDeviceOnline: false,
          secondsSinceLastUpdate: 0,
          activeAlerts: [],
          hasCriticalAlert: false,
          latestData: null,
        )) {
    // Watch for new data from MQTT
    ref.listen<SensorData?>(latestSensorProvider, (previous, next) {
      if (next != null) {
        _handleNewData(next);
      }
    });

    // Start timer to update "seconds ago" and offline status
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    
    // Pick up initial state if already populated
    final initialData = ref.read(latestSensorProvider);
    if (initialData != null) {
      _handleNewData(initialData);
    }
  }

  void _handleNewData(SensorData data) {
    _lastReceivedLocalTime = DateTime.now();
    final alerts = <String>[];
    bool critical = false;
    
    if (data.temperatureStatus == SensorStatus.critical) {
      alerts.add('Temperature is Critical');
      critical = true;
    } else if (data.temperatureStatus == SensorStatus.warning) {
      alerts.add('Temperature Warning');
    }
    
    if (data.humidityStatus == SensorStatus.critical) {
      alerts.add('Humidity is Critical');
      critical = true;
    } else if (data.humidityStatus == SensorStatus.warning) {
      alerts.add('Humidity Warning');
    }
    
    if (data.co2Status == SensorStatus.critical) {
      alerts.add('CO₂ is Critical');
      critical = true;
    } else if (data.co2Status == SensorStatus.warning) {
      alerts.add('CO₂ Warning');
    }

    if (data.lightStatus == SensorStatus.critical) {
      alerts.add('Light is Critical');
      critical = true;
    } else if (data.lightStatus == SensorStatus.warning) {
      alerts.add('Light Warning');
    }

    state = state.copyWith(
      isDeviceOnline: true,
      secondsSinceLastUpdate: 0,
      activeAlerts: alerts,
      hasCriticalAlert: critical,
      latestData: data,
    );
  }

  void _tick() {
    if (_lastReceivedLocalTime == null) return;

    final seconds = DateTime.now().difference(_lastReceivedLocalTime!).inSeconds;
    final isOnline = seconds <= 30;

    if (state.secondsSinceLastUpdate != seconds || state.isDeviceOnline != isOnline) {
      state = state.copyWith(
        secondsSinceLastUpdate: seconds,
        isDeviceOnline: isOnline,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref);
});
