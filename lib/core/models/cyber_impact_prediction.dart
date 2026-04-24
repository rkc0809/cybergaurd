import 'risk_level.dart';

class CyberImpactPrediction {
  const CyberImpactPrediction({
    required this.riskScore,
    required this.riskLevel,
    required this.impacts,
    required this.summary,
    required this.explanation,
    required this.recommendedAction,
  });

  final int riskScore;
  final RiskLevel riskLevel;
  final List<String> impacts;
  final String summary;
  final String explanation;
  final String recommendedAction;
}
