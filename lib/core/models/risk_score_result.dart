import 'risk_level.dart';
import 'risk_score_breakdown.dart';

class RiskScoreResult {
  const RiskScoreResult({
    required this.percentage,
    required this.category,
    required this.breakdown,
  });

  final int percentage;
  final RiskLevel category;
  final RiskScoreBreakdown breakdown;

  bool get isActionRequired => category == RiskLevel.high || category == RiskLevel.critical;
}
