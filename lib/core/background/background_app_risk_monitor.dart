import '../../features/app_scanner/data/services/local_app_scanner_service.dart';
import '../models/risk_level.dart';
import 'background_alert_service.dart';

class BackgroundAppRiskMonitor {
  BackgroundAppRiskMonitor({
    LocalAppScannerService? scannerService,
    BackgroundAlertService? alertService,
  })  : _scannerService = scannerService ?? LocalAppScannerService(),
        _alertService = alertService ?? BackgroundAlertService();

  final LocalAppScannerService _scannerService;
  final BackgroundAlertService _alertService;

  Future<BackgroundAppRiskScanResult> runScan() async {
    await _alertService.initialize();
    final scannedApps = await _scannerService.scanInstalledApps();
    final highRiskApps = filterHighRiskApps(scannedApps);

    await _alertService.showHighRiskAppsAlert(highRiskApps);

    return BackgroundAppRiskScanResult(
      scannedAppCount: scannedApps.length,
      highRiskApps: highRiskApps,
    );
  }

  List<ScannedAppRisk> filterHighRiskApps(List<ScannedAppRisk> apps) {
    return apps
        .where(
          (app) => app.riskLevel == RiskLevel.high || app.riskLevel == RiskLevel.critical,
        )
        .toList(growable: false);
  }
}

class BackgroundAppRiskScanResult {
  const BackgroundAppRiskScanResult({
    required this.scannedAppCount,
    required this.highRiskApps,
  });

  final int scannedAppCount;
  final List<ScannedAppRisk> highRiskApps;

  bool get hasHighRiskFindings => highRiskApps.isNotEmpty;
}
