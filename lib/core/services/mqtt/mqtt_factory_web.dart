import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient getClient(String server, String clientId, {bool isSecure = false}) {
  final scheme = isSecure ? 'wss' : 'ws';
  final port = isSecure ? 8084 : 8083;
  
  final client = MqttBrowserClient('$scheme://$server/mqtt', clientId);
  client.port = port;
  client.websocketProtocols = ['mqtt'];
  return client;
}
