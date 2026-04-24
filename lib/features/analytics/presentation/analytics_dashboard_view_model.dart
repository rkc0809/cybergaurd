import '../../../core/base/base_view_model.dart';
import '../../../core/models/risk_level.dart';
import '../../app_scanner/data/services/local_app_scanner_service.dart';

class AnalyticsDashboardViewModel extends BaseViewModel {
  AnalyticsDashboardViewModel(this._appScannerService);

  final LocalAppScannerService _appScannerService;
  List<ScannedAppRisk> _apps = [];

  List<ScannedAppRisk> get apps => _apps;
  int get totalAppsScanned => _apps.length;
  int get highRiskCount => _apps
      .where(
        (app) => app.riskLevel == RiskLevel.high || app.riskLevel == RiskLevel.critical,
      )
      .length;

  Map<RiskLevel, int> get categoryCounts {
    final counts = {
      RiskLevel.low: 0,
      RiskLevel.medium: 0,
      RiskLevel.high: 0,
      RiskLevel.critical: 0,
    };

    for (final app in _apps) {
      counts[app.riskLevel] = (counts[app.riskLevel] ?? 0) + 1;
    }

    return counts;
  }

  Future<void> load() async {
    await runBusyTask(() async {
      _apps = await _appScannerService.scanInstalledApps();
      notifyIfAlive();
    });
  }
}
