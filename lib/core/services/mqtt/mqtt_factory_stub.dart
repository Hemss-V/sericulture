import 'package:mqtt_client/mqtt_client.dart';

MqttClient getClient(String server, String clientId, {bool isSecure = false}) => 
    throw UnsupportedError('MQTT client not supported on this platform');
