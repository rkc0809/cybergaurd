import 'package:cyberguard/core/models/risk_factor_input.dart';
import 'package:cyberguard/core/models/risk_factor_weights.dart';
import 'package:cyberguard/core/models/risk_level.dart';
import 'package:cyberguard/core/services/risk_scoring_engine.dart';
import 'package:cyberguard/features/risk/data/models/risk_signal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RiskScoringEngine', () {
    test('returns low result for an empty risk profile', () {
      const engine = RiskScoringEngine();

      final result = engine.evaluate(RiskFactorInput.safe());

      expect(result.percentage, 0);
      expect(result.category, RiskLevel.low);
      expect(result.breakdown.total, 0);
    });

    test('calculates normalized multi-factor weighted score', () {
      const engine = RiskScoringEngine(
        weights: RiskFactorWeights(
          permissions: 0.3,
          behavior: 0.35,
          sourceTrust: 0.2,
          anomaly: 0.15,
        ),
      );

      final result = engine.evaluate(
        const RiskFactorInput(
          permissionsRisk: 1,
          behaviorRisk: 0.8,
          sourceTrustRisk: 0.5,
          anomalyRisk: 0.4,
        ),
      );

      expect(result.percentage, 74);
      expect(result.category, RiskLevel.high);
      expect(result.breakdown.permissionsContribution, closeTo(0.3, 0.001));
      expect(result.breakdown.behaviorContribution, closeTo(0.28, 0.001));
      expect(result.breakdown.sourceTrustContribution, closeTo(0.1, 0.001));
      expect(result.breakdown.anomalyContribution, closeTo(0.06, 0.001));
    });

    test('normalizes custom weights that do not add up to one', () {
      const engine = RiskScoringEngine(
        weights: RiskFactorWeights(
          permissions: 3,
          behavior: 3,
          sourceTrust: 2,
          anomaly: 2,
        ),
      );

      final result = engine.evaluate(
        const RiskFactorInput(
          permissionsRisk: 1,
          behaviorRisk: 1,
          sourceTrustRisk: 0,
          anomalyRisk: 0,
        ),
      );

      expect(result.percentage, 60);
      expect(result.category, RiskLevel.high);
    });

    test('clamps invalid factor values to the 0-1 range', () {
      const engine = RiskScoringEngine();

      final result = engine.evaluate(
        const RiskFactorInput(
          permissionsRisk: 2,
          behaviorRisk: -1,
          sourceTrustRisk: double.nan,
          anomalyRisk: 1,
        ),
      );

      expect(result.percentage, 45);
      expect(result.category, RiskLevel.medium);
    });

    test('classifies thresholds as low, medium, high, and critical', () {
      const engine = RiskScoringEngine();

      expect(engine.classify(30), RiskLevel.low);
      expect(engine.classify(31), RiskLevel.medium);
      expect(engine.classify(61), RiskLevel.high);
      expect(engine.classify(81), RiskLevel.critical);
    });

    test('keeps signal-based scoring available for existing features', () {
      const engine = RiskScoringEngine();
      final score = engine.calculateScore(
        const [
          RiskSignal(
            source: 'test',
            title: 'critical',
            description: 'critical signal',
            severity: 1,
            confidence: 1,
            weight: 2,
          ),
          RiskSignal(
            source: 'test',
            title: 'medium',
            description: 'medium signal',
            severity: 0.5,
            confidence: 0.8,
            weight: 1,
          ),
        ],
      );

      expect(score, 28);
      expect(engine.classify(score), RiskLevel.low);
    });
  });
}
