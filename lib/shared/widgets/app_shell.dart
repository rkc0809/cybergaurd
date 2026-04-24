import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/navigation/app_routes.dart';
import '../../core/theme/app_colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.selectedIndex,
    required this.child,
    this.actions,
    super.key,
  });

  final String title;
  final int selectedIndex;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          final route = switch (index) {
            0 => AppRoutes.dashboard,
            1 => AppRoutes.analytics,
            2 => AppRoutes.appScanner,
            3 => AppRoutes.fileAnalyzer,
            _ => AppRoutes.fraudDetector,
          };
          context.go(route);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.donut_large_outlined),
            selectedIcon: Icon(Icons.donut_large),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.apps_outlined),
            selectedIcon: Icon(Icons.apps),
            label: 'Apps',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Files',
          ),
          NavigationDestination(
            icon: Icon(Icons.link_outlined),
            selectedIcon: Icon(Icons.link),
            label: 'Fraud',
          ),
        ],
      ),
    );
  }
}
