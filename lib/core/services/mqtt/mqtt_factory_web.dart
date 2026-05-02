import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient getClient(String server, String clientId, {bool isSecure = false}) {
  final scheme = isSecure ? 'wss' : 'ws';
  // Eclipse public broker uses standard web ports, preventing firewall blocks
  final port = isSecure ? 443 : 80;
  
  final client = MqttBrowserClient('$scheme://$server/mqtt', clientId);
  client.port = port;
  // Let the package handle the default websocket protocols
  return client;
}
