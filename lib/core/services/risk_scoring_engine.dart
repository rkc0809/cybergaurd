import '../../features/risk/data/models/risk_signal.dart';
import '../models/risk_factor_input.dart';
import '../models/risk_factor_weights.dart';
import '../models/risk_level.dart';
import '../models/risk_score_breakdown.dart';
import '../models/risk_score_result.dart';

class RiskScoringEngine {
  const RiskScoringEngine({
    this.weights = const RiskFactorWeights(),
  });

  final RiskFactorWeights weights;

  RiskScoreResult evaluate(RiskFactorInput input) {
    final totalWeight = weights.total;
    if (totalWeight <= 0) {
      return RiskScoreResult(
        percentage: 0,
        category: classify(0),
        breakdown: const RiskScoreBreakdown(
          permissionsContribution: 0,
          behaviorContribution: 0,
          sourceTrustContribution: 0,
          anomalyContribution: 0,
        ),
      );
    }

    final normalizedWeights = RiskFactorWeights(
      permissions: weights.permissions / totalWeight,
      behavior: weights.behavior / totalWeight,
      sourceTrust: weights.sourceTrust / totalWeight,
      anomaly: weights.anomaly / totalWeight,
    );
    final breakdown = RiskScoreBreakdown(
      permissionsContribution: _normalize(input.permissionsRisk) * normalizedWeights.permissions,
      behaviorContribution: _normalize(input.behaviorRisk) * normalizedWeights.behavior,
      sourceTrustContribution: _normalize(input.sourceTrustRisk) * normalizedWeights.sourceTrust,
      anomalyContribution: _normalize(input.anomalyRisk) * normalizedWeights.anomaly,
    );
    final percentage = (breakdown.total * 100).round().clamp(0, 100).toInt();

    return RiskScoreResult(
      percentage: percentage,
      category: classify(percentage),
      breakdown: breakdown,
    );
  }

  int calculateScore(List<RiskSignal> signals) {
    if (signals.isEmpty) {
      return evaluate(RiskFactorInput.safe()).percentage;
    }

    final weightedSum = signals.fold<double>(
      0,
      (sum, signal) => sum + (signal.severity * signal.confidence * signal.weight),
    );
    final maxWeight = signals.fold<double>(0, (sum, signal) => sum + signal.weight);

    if (maxWeight == 0) {
      return 0;
    }

    return evaluate(
      RiskFactorInput(
        permissionsRisk: 0,
        behaviorRisk: weightedSum / maxWeight,
        sourceTrustRisk: 0,
        anomalyRisk: signals.length >= 3 ? 0.35 : 0,
      ),
    ).percentage;
  }

  RiskLevel classify(int score) => RiskLevel.fromScore(score);

  double _normalize(double value) {
    if (value.isNaN || value.isInfinite) {
      return 0;
    }
    return value.clamp(0, 1).toDouble();
  }
}
