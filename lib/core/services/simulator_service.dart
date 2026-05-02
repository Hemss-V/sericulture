import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../constants/mqtt_constants.dart';
import '../models/sensor_data.dart';
import '../models/actuator_status.dart';
import 'mqtt/mqtt_factory.dart';

/// Simulates the physical hardware field device.
/// Runs as a separate MQTT client with its own connection.
class SimulatorService {
  MqttClient? _client;
  Timer? _timer;
  final _rand = Random();

  // Simulated hardware state
  double _temp = 28.0;
  bool _fan = false;
  bool _heater = false;
  bool _mister = false;

  bool _useSecureWeb = false;

  Future<void> start() async {
    _connectLoop();
  }

  Future<void> _connectLoop() async {
    // Keep client ID under 23 chars to prevent silent broker disconnects
    final randId = _rand.nextInt(99999);
    final clientId = 'seri_s${DateTime.now().millisecondsSinceEpoch % 100000}_$randId';
    _client = getClient(MqttConstants.brokerHost, clientId, isSecure: _useSecureWeb);

    if (!kIsWeb) {
      _client!.port = MqttConstants.brokerPort;
    }
    
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 60;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client!.connectionMessage = connMess;

    _client!.onDisconnected = () {
      final reason = _client?.connectionStatus?.returnCode?.toString() ?? 'Unknown';
      debugPrint('Simulator: Disconnected. Reason: $reason. Reconnecting in 3s...');
      _timer?.cancel();
      Future.delayed(const Duration(seconds: 3), _connectLoop);
    };

    try {
      debugPrint('Simulator: Connecting (SecureWeb: $_useSecureWeb)...');
      await _client!.connect();
      debugPrint('Simulator: Connected to broker');
    } catch (e) {
      debugPrint('Simulator: Connection failed - $e');
      _client?.disconnect();
      
      if (kIsWeb && !_useSecureWeb) {
        debugPrint('Simulator: Web connection failed. Falling back to secure WSS (8884)...');
        _useSecureWeb = true;
        Future.delayed(const Duration(milliseconds: 500), _connectLoop);
        return;
      }
      
      Future.delayed(const Duration(seconds: 3), _connectLoop);
      return;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      _client!.subscribe(MqttConstants.topicActuatorCmd, MqttQos.atLeastOnce);
      _client!.updates!.listen(_onMessage);
      
      // Publish sensor data every 5 seconds
      _timer = Timer.periodic(const Duration(seconds: 5), (_) => _publishSensorData());
      
      // Publish initial actuator status
      _publishActuatorStatus();
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final recMess = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    debugPrint('Simulator Rx [${event[0].topic}]: $payload');

    if (event[0].topic == MqttConstants.topicActuatorCmd) {
      try {
        final data = jsonDecode(payload);
        final device = data['device'] as String?;
        final action = data['action'] as String?;

        if (device != null && action != null) {
          final isOn = action.toUpperCase() == 'ON';
          if (device == 'fan') {
            _fan = isOn;
          } else if (device == 'heater') {
            _heater = isOn;
          } else if (device == 'mister') {
            _mister = isOn;
          }

          // Simulate physical response delay
          Future.delayed(const Duration(milliseconds: 500), () {
            _publishActuatorStatus();
          });
        }
      } catch (e) {
        debugPrint('Simulator: Error parsing command JSON - $e');
      }
    }
  }

  void _publishSensorData() {
    if (_client == null || _client!.connectionStatus!.state != MqttConnectionState.connected) return;

    // Slow drifting temperature for realistic chart lines
    _temp += (_rand.nextDouble() - 0.5) * 1.5;
    _temp = _temp.clamp(24.0, 36.0);

    final humidity = 58.0 + _rand.nextDouble() * 27.0; // 58-85
    final co2 = 800.0 + _rand.nextDouble() * 1000.0;   // 800-1800
    final light = 500.0 + _rand.nextDouble() * 4500.0; // 500-5000

    final data = SensorData(
      temperature: _temp,
      humidity: humidity,
      co2: co2,
      light: light,
      timestamp: DateTime.now(),
    );

    final payload = jsonEncode(data.toJson());
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    debugPrint('Simulator Tx [${MqttConstants.topicSensors}]: $payload');
    _client!.publishMessage(MqttConstants.topicSensors, MqttQos.atLeastOnce, builder.payload!);
  }

  void _publishActuatorStatus() {
    if (_client == null || _client!.connectionStatus!.state != MqttConnectionState.connected) return;

    final status = ActuatorStatus(
      fan: _fan,
      heater: _heater,
      mister: _mister,
      status: 'online',
      timestamp: DateTime.now(),
    );

    final payload = jsonEncode(status.toJson());
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    debugPrint('Simulator Tx [${MqttConstants.topicActuatorStatus}]: $payload');
    _client!.publishMessage(MqttConstants.topicActuatorStatus, MqttQos.atLeastOnce, builder.payload!);
  }

  void stop() {
    _timer?.cancel();
    _client?.disconnect();
    debugPrint('Simulator: Stopped');
  }
}
