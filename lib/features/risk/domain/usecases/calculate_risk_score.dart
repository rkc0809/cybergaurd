import '../../../../core/models/risk_level.dart';
import '../../../../core/models/risk_factor_input.dart';
import '../../../../core/models/risk_score_result.dart';
import '../../../../core/services/risk_scoring_engine.dart';
import '../../data/models/risk_signal.dart';

class CalculateRiskScore {
  const CalculateRiskScore(this.engine);

  final RiskScoringEngine engine;

  ({int score, RiskLevel level}) call(List<RiskSignal> signals) {
    final score = engine.calculateScore(signals);
    return (score: score, level: engine.classify(score));
  }

  RiskScoreResult evaluate(RiskFactorInput input) {
    return engine.evaluate(input);
  }
}
