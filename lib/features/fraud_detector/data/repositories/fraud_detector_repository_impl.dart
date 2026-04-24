import '../../../../core/services/risk_impact_prediction_engine.dart';
import '../../../../core/services/risk_scoring_engine.dart';
import '../../../risk/data/models/risk_signal.dart';
import '../../../risk/domain/entities/risk_assessment.dart';
import '../../../risk/domain/repositories/risk_repository.dart';
import '../../domain/entities/fraud_detection_result.dart';
import '../../domain/repositories/fraud_detector_repository.dart';
import '../services/local_fraud_detection_service.dart';

class FraudDetectorRepositoryImpl implements FraudDetectorRepository {
  FraudDetectorRepositoryImpl({
    required LocalFraudDetectionService service,
    required RiskRepository riskRepository,
  })  : _service = service,
        _riskRepository = riskRepository,
        _engine = RiskScoringEngine(),
        _impactPredictionEngine = const RiskImpactPredictionEngine();

  final LocalFraudDetectionService _service;
  final RiskRepository _riskRepository;
  final RiskScoringEngine _engine;
  final RiskImpactPredictionEngine _impactPredictionEngine;

  @override
  Future<FraudDetectionResult> inspectMessageOrUrl(String input) async {
    final analysis = await _service.analyze(input);
    final matches = analysis.evidence.map((item) => item.label).toList();
    final signals = analysis.evidence.map((evidence) {
      return RiskSignal(
        source: 'Message',
        title: evidence.label,
        description: 'Input contains a known fraud pattern: ${evidence.label}.',
        severity: evidence.weight,
        confidence: 0.9,
        weight: 1,
      );
    }).toList();
    final score = analysis.probability;
    final impactPrediction = _impactPredictionEngine.predict(score);
    final result = FraudDetectionResult(
      input: input,
      score: score,
      level: _engine.classify(score),
      matches: matches.isEmpty ? ['No common fraud patterns detected'] : matches,
      explanation: analysis.warningMessage,
      warningMessage: analysis.warningMessage,
      predictedImpact: impactPrediction.summary,
    );

    await _riskRepository.saveAssessment(
      RiskAssessment(
        id: 'fraud-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Message and URL fraud check',
        category: 'Messages',
        score: result.score,
        level: result.level,
        signals: signals,
        assessedAt: DateTime.now(),
      ),
    );

    return result;
  }
}
