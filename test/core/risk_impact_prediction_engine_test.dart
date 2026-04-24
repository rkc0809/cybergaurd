import 'package:cyberguard/core/models/risk_level.dart';
import 'package:cyberguard/core/services/risk_impact_prediction_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RiskImpactPredictionEngine', () {
    test('maps low scores to minimal user-facing impact', () {
      const engine = RiskImpactPredictionEngine();

      final prediction = engine.predict(12);

      expect(prediction.riskLevel, RiskLevel.low);
      expect(prediction.summary, 'Minimal risk expected');
      expect(prediction.impacts, contains('Minimal risk'));
    });

    test('maps medium scores to privacy and tracking impacts', () {
      const engine = RiskImpactPredictionEngine();

      final prediction = engine.predict(45);

      expect(prediction.riskLevel, RiskLevel.medium);
      expect(prediction.impacts, contains('Tracking'));
      expect(prediction.impacts, contains('Privacy leakage'));
    });

    test('maps high scores to data theft and account compromise impacts', () {
      const engine = RiskImpactPredictionEngine();

      final prediction = engine.predict(72);

      expect(prediction.riskLevel, RiskLevel.high);
      expect(prediction.impacts, contains('Data theft'));
      expect(prediction.impacts, contains('Account compromise'));
    });

    test('maps critical scores to severe compromise explanations', () {
      const engine = RiskImpactPredictionEngine();

      final prediction = engine.predict(94);

      expect(prediction.riskLevel, RiskLevel.critical);
      expect(prediction.summary, 'Severe compromise or fraud risk');
      expect(prediction.explanation, contains('account takeover'));
    });

    test('clamps out-of-range scores before predicting', () {
      const engine = RiskImpactPredictionEngine();

      expect(engine.predict(-20).riskScore, 0);
      expect(engine.predict(130).riskScore, 100);
    });
  });
}
