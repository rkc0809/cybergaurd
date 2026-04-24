import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../logging/app_logger.dart';
import 'background_app_risk_monitor.dart';
import 'background_monitoring_config.dart';

@pragma('vm:entry-point')
void cyberGuardBackgroundCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    if (taskName != BackgroundMonitoringConfig.appRiskScanTask) {
      return true;
    }

    try {
      final monitor = BackgroundAppRiskMonitor();
      await monitor.runScan();
      return true;
    } catch (error, stackTrace) {
      AppLogger.warning(
        'Background app risk scan failed.',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  });
}
