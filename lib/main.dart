import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/shell/main_shell.dart';

/// Entry point. Phase 2 will add async init (notifications, storage, MQTT).
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for this release.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Immersive dark status bar.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF111A15),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: SericultureApp(),
    ),
  );
}

class SericultureApp extends ConsumerWidget {
  const SericultureApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Sericulture IoT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Phase 1: start at Login; Phase 2 will check stored session and skip
      home: const MainShell(),
    );
  }
}
