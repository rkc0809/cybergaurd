import '../background/background_monitoring_service.dart';
import '../../features/app_scanner/data/repositories/app_scanner_repository_impl.dart';
import '../../features/app_scanner/data/services/local_app_scanner_service.dart';
import '../../features/app_scanner/domain/repositories/app_scanner_repository.dart';
import '../../features/file_analyzer/data/repositories/file_analyzer_repository_impl.dart';
import '../../features/file_analyzer/data/services/local_file_threat_service.dart';
import '../../features/file_analyzer/domain/repositories/file_analyzer_repository.dart';
import '../../features/fraud_detector/data/repositories/fraud_detector_repository_impl.dart';
import '../../features/fraud_detector/data/services/local_fraud_detection_service.dart';
import '../../features/fraud_detector/domain/repositories/fraud_detector_repository.dart';
import '../../features/risk/data/repositories/in_memory_risk_repository.dart';
import '../../features/risk/domain/repositories/risk_repository.dart';
import 'risk_scoring_engine.dart';

class AppDependencies {
  const AppDependencies({
    required this.riskScoringEngine,
    required this.riskRepository,
    required this.appScannerService,
    required this.fileThreatService,
    required this.fraudDetectionService,
    required this.appScannerRepository,
    required this.fileAnalyzerRepository,
    required this.fraudDetectorRepository,
    required this.backgroundMonitoringService,
  });

  final RiskScoringEngine riskScoringEngine;
  final RiskRepository riskRepository;
  final LocalAppScannerService appScannerService;
  final LocalFileThreatService fileThreatService;
  final LocalFraudDetectionService fraudDetectionService;
  final AppScannerRepository appScannerRepository;
  final FileAnalyzerRepository fileAnalyzerRepository;
  final FraudDetectorRepository fraudDetectorRepository;
  final BackgroundMonitoringService backgroundMonitoringService;

  factory AppDependencies.bootstrap() {
    final riskScoringEngine = const RiskScoringEngine();
    final riskRepository = InMemoryRiskRepository(riskScoringEngine);
    final appScannerService = LocalAppScannerService(
      riskScoringEngine: riskScoringEngine,
    );
    final fileThreatService = LocalFileThreatService();
    final fraudDetectionService = LocalFraudDetectionService();

    return AppDependencies(
      riskScoringEngine: riskScoringEngine,
      riskRepository: riskRepository,
      appScannerService: appScannerService,
      fileThreatService: fileThreatService,
      fraudDetectionService: fraudDetectionService,
      appScannerRepository: AppScannerRepositoryImpl(
        service: appScannerService,
        riskRepository: riskRepository,
      ),
      fileAnalyzerRepository: FileAnalyzerRepositoryImpl(
        service: fileThreatService,
        riskRepository: riskRepository,
      ),
      fraudDetectorRepository: FraudDetectorRepositoryImpl(
        service: fraudDetectionService,
        riskRepository: riskRepository,
      ),
      backgroundMonitoringService: BackgroundMonitoringService(),
    );
  }
}
