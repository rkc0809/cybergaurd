import '../../../../core/models/risk_level.dart';

class FraudDetectionResult {
  const FraudDetectionResult({
    required this.input,
    required this.score,
    required this.level,
    required this.matches,
    required this.explanation,
    required this.warningMessage,
    required this.predictedImpact,
  });

  final String input;
  final int score;
  final RiskLevel level;
  final List<String> matches;
  final String explanation;
  final String warningMessage;
  final String predictedImpact;

  int get fraudProbability => score;
}
