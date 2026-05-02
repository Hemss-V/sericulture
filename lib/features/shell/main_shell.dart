import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../charts/screens/charts_screen.dart';
import '../alerts/screens/alerts_screen.dart';
import '../actuators/screens/actuators_screen.dart';
import '../settings/screens/settings_screen.dart';

/// Tracks the currently selected bottom nav index.
final currentNavIndexProvider = StateProvider<int>((ref) => 0);

/// Main shell with bottom navigation bar — wraps all 5 feature screens.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _screens = [
    DashboardScreen(),
    ChartsScreen(),
    AlertsScreen(),
    ActuatorsScreen(),
    SettingsScreen(),
  ];

  static const _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard_rounded),
      label: AppStrings.navDashboard,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.show_chart_outlined),
      activeIcon: Icon(Icons.show_chart_rounded),
      label: AppStrings.navCharts,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications_outlined),
      activeIcon: Icon(Icons.notifications_rounded),
      label: AppStrings.navAlerts,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_remote_outlined),
      activeIcon: Icon(Icons.settings_remote_rounded),
      label: AppStrings.navControl,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.tune_outlined),
      activeIcon: Icon(Icons.tune_rounded),
      label: AppStrings.navSettings,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) =>
              ref.read(currentNavIndexProvider.notifier).state = index,
          items: _navItems,
        ),
      ),
    );
  }
}
