import 'package:workmanager/workmanager.dart';

import 'background_alert_service.dart';
import 'background_monitoring_callback.dart';
import 'background_monitoring_config.dart';

class BackgroundMonitoringService {
  BackgroundMonitoringService({
    BackgroundAlertService? alertService,
    Workmanager? workmanager,
  })  : _alertService = alertService ?? BackgroundAlertService(),
        _workmanager = workmanager ?? Workmanager();

  final BackgroundAlertService _alertService;
  final Workmanager _workmanager;
  bool _isInitialized = false;

  Future<void> initialize({
    bool requestNotificationPermission = false,
    bool enableDebugLogging = false,
  }) async {
    if (_isInitialized) {
      return;
    }

    await _alertService.initialize();
    if (requestNotificationPermission) {
      await _alertService.requestAndroidNotificationPermission();
    }
    await _workmanager.initialize(
      cyberGuardBackgroundCallbackDispatcher,
      isInDebugMode: enableDebugLogging,
    );
    _isInitialized = true;
  }

  Future<void> startPeriodicAppScanning({
    Duration frequency = BackgroundMonitoringConfig.defaultScanFrequency,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    await _workmanager.registerPeriodicTask(
      BackgroundMonitoringConfig.appRiskScanUniqueName,
      BackgroundMonitoringConfig.appRiskScanTask,
      frequency: _androidSafeFrequency(frequency),
      initialDelay: BackgroundMonitoringConfig.androidMinimumPeriodicFrequency,
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: true,
      ),
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 30),
    );
  }

  Future<void> stopPeriodicAppScanning() {
    return _workmanager.cancelByUniqueName(
      BackgroundMonitoringConfig.appRiskScanUniqueName,
    );
  }

  Duration _androidSafeFrequency(Duration requestedFrequency) {
    if (requestedFrequency < BackgroundMonitoringConfig.androidMinimumPeriodicFrequency) {
      return BackgroundMonitoringConfig.androidMinimumPeriodicFrequency;
    }
    return requestedFrequency;
  }
}
