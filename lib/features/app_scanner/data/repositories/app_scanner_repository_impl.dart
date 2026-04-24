import '../../../../core/models/risk_factor_input.dart';
import '../../../../core/services/risk_scoring_engine.dart';
import '../../../risk/data/models/risk_signal.dart';
import '../../../risk/domain/entities/risk_assessment.dart';
import '../../../risk/domain/repositories/risk_repository.dart';
import '../../domain/entities/installed_app.dart';
import '../../domain/repositories/app_scanner_repository.dart';
import '../services/local_app_scanner_service.dart';

class AppScannerRepositoryImpl implements AppScannerRepository {
  AppScannerRepositoryImpl({
    required LocalAppScannerService service,
    required RiskRepository riskRepository,
  })  : _service = service,
        _riskRepository = riskRepository,
        _engine = RiskScoringEngine();

  final LocalAppScannerService _service;
  final RiskRepository _riskRepository;
  final RiskScoringEngine _engine;

  @override
  Future<List<InstalledApp>> scanInstalledApps() async {
    final scannedApps = await _service.scanInstalledApps();
    final apps = scannedApps.map(_toInstalledApp).toList();
    final signals = apps.expand((app) {
      return app.findings.map(
        (finding) => RiskSignal(
          source: app.displayName,
          title: finding,
          description: '${app.displayName} requested ${app.permissions.length} permissions.',
          severity: app.riskScore / 100,
          confidence: 0.82,
          weight: 1.1,
        ),
      );
    }).toList();

    final score = _engine
        .evaluate(
          RiskFactorInput(
            permissionsRisk: _average(apps.map((app) => app.riskScore / 100)),
            behaviorRisk: _average(signals.map((signal) => signal.severity)),
            sourceTrustRisk: apps.any((app) => app.packageName.contains('freevpn')) ? 0.7 : 0.2,
            anomalyRisk: apps.isEmpty
                ? 0
                : apps.where((app) => app.riskScore >= 60).length / apps.length,
          ),
        )
        .percentage;
    await _riskRepository.saveAssessment(
      RiskAssessment(
        id: 'app-scan-${DateTime.now().millisecondsSinceEpoch}',
        title: 'App risk scan',
        category: 'Applications',
        score: score,
        level: _engine.classify(score),
        signals: signals,
        assessedAt: DateTime.now(),
      ),
    );

    return apps;
  }

  InstalledApp _toInstalledApp(ScannedAppRisk scannedApp) {
    return InstalledApp(
      packageName: scannedApp.packageName,
      displayName: scannedApp.appName,
      permissions: scannedApp.permissions,
      riskScore: scannedApp.riskScore,
      riskLevel: scannedApp.riskLevel,
      findings: scannedApp.findings,
    );
  }

  double _average(Iterable<double> values) {
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((sum, value) => sum + value) / values.length;
  }
}
