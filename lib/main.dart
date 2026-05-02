import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/storage_service.dart';
import 'core/providers/mqtt_providers.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/shell/main_shell.dart';

/// Initialises services before the widget tree is mounted, then runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise persistent storage and seed defaults on first run.
  await StorageService.instance.init();

  // Lock to portrait.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Immersive dark system chrome.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF111A15),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Determine the start screen based on the restored session.
  final savedUser = StorageService.instance.getUser();

  // Initialise global ProviderContainer to start services before runApp
  final container = ProviderContainer();

  // Kick off MQTT connection and Simulator. 
  // We do not wait for them to finish; they connect asynchronously.
  container.read(mqttServiceProvider.notifier).connect();
  container.read(simulatorServiceProvider).start();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: SericultureApp(startAuthenticated: savedUser != null),
    ),
  );
}

class SericultureApp extends StatelessWidget {
  /// Whether the app opens directly to [MainShell] (true) or [LoginScreen] (false).
  final bool startAuthenticated;

  const SericultureApp({super.key, required this.startAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sericulture IoT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: startAuthenticated ? const MainShell() : const LoginScreen(),
    );
  }
}
