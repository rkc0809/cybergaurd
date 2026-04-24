import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app/cyber_guard_app.dart';
import 'core/logging/app_logger.dart';
import 'core/services/app_dependencies.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final dependencies = AppDependencies.bootstrap();
      await _startBackgroundMonitoring(dependencies);
      runApp(CyberGuardApp(dependencies: dependencies));
    },
    (error, stackTrace) {
      AppLogger.fatal(
        'Unhandled application error',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
}

Future<void> _startBackgroundMonitoring(AppDependencies dependencies) async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    return;
  }

  try {
    await dependencies.backgroundMonitoringService.initialize(
      requestNotificationPermission: true,
    );
    await dependencies.backgroundMonitoringService.startPeriodicAppScanning();
  } catch (error, stackTrace) {
    AppLogger.warning(
      'Background monitoring could not be started. The app will continue in foreground mode.',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
