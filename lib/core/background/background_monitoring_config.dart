class BackgroundMonitoringConfig {
  const BackgroundMonitoringConfig._();

  static const appRiskScanUniqueName = 'cyberguard.periodic_app_risk_scan';
  static const appRiskScanTask = 'cyberguard.app_risk_scan_task';
  static const notificationChannelId = 'cyberguard_security_alerts';
  static const notificationChannelName = 'CyberGuard security alerts';
  static const notificationChannelDescription =
      'Alerts when CyberGuard finds high-risk or critical app findings.';

  static const defaultScanFrequency = Duration(hours: 6);
  static const androidMinimumPeriodicFrequency = Duration(minutes: 15);
}
