import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../constants/mqtt_constants.dart';
import '../models/sensor_data.dart';
import '../models/actuator_status.dart';
import '../models/command_log.dart';
import '../providers/mqtt_providers.dart';
import 'mqtt/mqtt_factory.dart';

/// Riverpod StateNotifier managing the live MQTT connection.
/// State is the connection status: 'disconnected', 'connecting', 'connected', 'error'.
class MqttService extends StateNotifier<String> {
  final Ref _ref;
  MqttService(this._ref) : super('disconnected');

  MqttClient? _client;
  Timer? _reconnectTimer;
  bool _useSecureWeb = false;

  final _sensorCtrl = StreamController<SensorData>.broadcast();
  final _actuatorCtrl = StreamController<ActuatorStatus>.broadcast();

  Stream<SensorData> get sensorStream => _sensorCtrl.stream;
  Stream<ActuatorStatus> get actuatorStream => _actuatorCtrl.stream;

  Future<void> connect() async {
    if (state == 'connecting' || state == 'connected') return;
    state = 'connecting';

    // Keep client ID under 23 chars to prevent silent broker disconnects
    final randId = Random().nextInt(99999);
    final clientId = 'seri_a${DateTime.now().millisecondsSinceEpoch % 100000}_$randId';
    _client = getClient(MqttConstants.brokerHost, clientId, isSecure: _useSecureWeb);

    // Only set raw TCP port if running native. Factory handles WS port for Web.
    if (!kIsWeb) {
      _client!.port = MqttConstants.brokerPort; // 1883
    }
    
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 60;
    _client!.onDisconnected = _onDisconnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean();
    _client!.connectionMessage = connMess;

    try {
      debugPrint('MQTT App: Connecting to ${MqttConstants.brokerHost} (SecureWeb: $_useSecureWeb)...');
      await _client!.connect();
    } catch (e) {
      debugPrint('MQTT App: Connection failed - $e');
      _client!.disconnect();
      
      if (kIsWeb && !_useSecureWeb) {
        debugPrint('MQTT App: Web connection on port 80 failed. Falling back to secure WSS (443)...');
        _useSecureWeb = true;
        state = 'disconnected';
        _scheduleReconnect(delayMs: 500); // Quick retry for fallback
        return;
      }
      
      state = 'error';
      _scheduleReconnect();
      return;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('MQTT App: Connected!');
      state = 'connected';
      
      _client!.subscribe(MqttConstants.topicSensors, MqttQos.atLeastOnce);
      _client!.subscribe(MqttConstants.topicActuatorStatus, MqttQos.atLeastOnce);

      _client!.updates!.listen(_onMessage);
    } else {
      debugPrint('MQTT App: Connection failed, state is ${_client!.connectionStatus!.state}');
      _client!.disconnect();
      state = 'error';
      _scheduleReconnect();
    }
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> event) {
    final recMess = event[0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    debugPrint('MQTT App Rx [${event[0].topic}]: $payload');

    if (event[0].topic == MqttConstants.topicSensors) {
      try {
        final data = SensorData.fromJson(jsonDecode(payload));
        _sensorCtrl.add(data);
        _ref.read(latestSensorProvider.notifier).state = data;
      } catch (e) {
        debugPrint('MQTT App: Error parsing sensor data - $e');
      }
    } else if (event[0].topic == MqttConstants.topicActuatorStatus) {
      try {
        final status = ActuatorStatus.fromJson(jsonDecode(payload));
        _actuatorCtrl.add(status);
        _ref.read(latestActuatorProvider.notifier).state = status;
      } catch (e) {
        debugPrint('MQTT App: Error parsing actuator status - $e');
      }
    }
  }

  void _onDisconnected() {
    final reason = _client?.connectionStatus?.returnCode?.toString() ?? 'Unknown';
    debugPrint('MQTT App: Disconnected. Reason: $reason');
    if (state != 'disconnected') { // Unintentional disconnect
      state = 'error';
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect({int delayMs = 3000}) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(milliseconds: delayMs), () {
      debugPrint('MQTT App: Auto-reconnecting...');
      connect();
    });
  }

  /// Publishes an actuator command to the broker.
  void publishCommand(CommandLog command) {
    if (state != 'connected' || _client == null) {
      debugPrint('MQTT App: Cannot publish, not connected');
      return;
    }

    final payload = jsonEncode(command.toMqttPayload());
    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    debugPrint('MQTT App Tx [${MqttConstants.topicActuatorCmd}]: $payload');
    _client!.publishMessage(
      MqttConstants.topicActuatorCmd,
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    state = 'disconnected';
    _client?.disconnect();
  }

  @override
  void dispose() {
    _reconnectTimer?.cancel();
    _client?.disconnect();
    _sensorCtrl.close();
    _actuatorCtrl.close();
    super.dispose();
  }
}
