import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

MqttClient getClient(String server, String clientId) {
  // HiveMQ public broker uses port 8000 for WebSockets
  return MqttBrowserClient('ws://$server/mqtt', clientId)..port = 8000;
}
