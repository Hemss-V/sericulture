import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/storage_service.dart';
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
  // StorageService is already initialised, so getUser() is safe here.
  final savedUser = StorageService.instance.getUser();

  runApp(
    ProviderScope(
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
