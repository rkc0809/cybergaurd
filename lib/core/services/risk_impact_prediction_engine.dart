import '../models/cyber_impact_prediction.dart';
import '../models/risk_level.dart';

class RiskImpactPredictionEngine {
  const RiskImpactPredictionEngine();

  CyberImpactPrediction predict(int riskScore) {
    final clampedScore = riskScore.clamp(0, 100).toInt();
    final level = RiskLevel.fromScore(clampedScore);

    return switch (level) {
      RiskLevel.low => CyberImpactPrediction(
          riskScore: clampedScore,
          riskLevel: level,
          impacts: const ['Minimal risk'],
          summary: 'Minimal risk expected',
          explanation:
              'This item shows few or no meaningful risk signals. It is unlikely to cause immediate harm based on the current scan.',
          recommendedAction: 'Continue normal use and keep monitoring for changes.',
        ),
      RiskLevel.medium => CyberImpactPrediction(
          riskScore: clampedScore,
          riskLevel: level,
          impacts: const [
            'Tracking',
            'Privacy leakage',
            'Unwanted data collection',
          ],
          summary: 'Possible tracking or privacy leakage',
          explanation:
              'This item has enough suspicious signals to justify caution. The most likely impact is privacy exposure, tracking, or collection of unnecessary user data.',
          recommendedAction: 'Review permissions, sender, source, and necessity before trusting it.',
        ),
      RiskLevel.high => CyberImpactPrediction(
          riskScore: clampedScore,
          riskLevel: level,
          impacts: const [
            'Data theft',
            'Account compromise',
            'Credential exposure',
          ],
          summary: 'Possible data theft or account compromise',
          explanation:
              'This item contains strong risk indicators. It may attempt to steal sensitive data, capture credentials, or compromise an account.',
          recommendedAction: 'Avoid interaction, revoke sensitive access, and verify through an official channel.',
        ),
      RiskLevel.critical => CyberImpactPrediction(
          riskScore: clampedScore,
          riskLevel: level,
          impacts: const [
            'Data theft',
            'Account compromise',
            'Financial fraud',
            'Malware exposure',
          ],
          summary: 'Severe compromise or fraud risk',
          explanation:
              'This item combines multiple severe signals. It may lead to credential theft, account takeover, payment fraud, malware exposure, or loss of sensitive data.',
          recommendedAction: 'Do not proceed. Quarantine, delete, block, or report it immediately.',
        ),
    };
  }
}
