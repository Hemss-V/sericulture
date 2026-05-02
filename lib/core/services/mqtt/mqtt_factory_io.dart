import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient getClient(String server, String clientId, {bool isSecure = false}) {
  return MqttServerClient(server, clientId);
}
