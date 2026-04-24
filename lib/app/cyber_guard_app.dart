import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/app_dependencies.dart';
import '../core/theme/app_theme.dart';
import 'navigation/app_router.dart';

class CyberGuardApp extends StatelessWidget {
  const CyberGuardApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final router = buildAppRouter(dependencies);

    return Provider<AppDependencies>.value(
      value: dependencies,
      child: MaterialApp.router(
        title: 'CyberGuard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.dark,
        routerConfig: router,
      ),
    );
  }
}
