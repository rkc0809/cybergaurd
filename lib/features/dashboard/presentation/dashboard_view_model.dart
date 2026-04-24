import '../../../core/base/base_view_model.dart';
import '../../app_scanner/domain/repositories/app_scanner_repository.dart';
import '../../risk/domain/entities/risk_assessment.dart';
import '../../risk/domain/repositories/risk_repository.dart';

class DashboardViewModel extends BaseViewModel {
  DashboardViewModel({
    required RiskRepository riskRepository,
    required AppScannerRepository appScannerRepository,
  })  : _riskRepository = riskRepository,
        _appScannerRepository = appScannerRepository;

  final RiskRepository _riskRepository;
  final AppScannerRepository _appScannerRepository;
  List<RiskAssessment> _assessments = [];

  List<RiskAssessment> get assessments => _assessments;
  RiskAssessment? get latestAssessment => _assessments.isEmpty ? null : _assessments.first;
  double get averageScore {
    if (_assessments.isEmpty) {
      return 0;
    }
    final total = _assessments.fold<int>(0, (sum, item) => sum + item.score);
    return total / _assessments.length;
  }

  Future<void> load() async {
    await runBusyTask(() async {
      _assessments = await _riskRepository.getAssessments();
      notifyIfAlive();
    });
  }

  Future<void> runFullScan() async {
    await runBusyTask(() async {
      await _appScannerRepository.scanInstalledApps();
      _assessments = await _riskRepository.getAssessments();
      notifyIfAlive();
    });
  }
}
