import '../../../../core/models/risk_level.dart';
import '../../data/models/risk_signal.dart';

class RiskAssessment {
  const RiskAssessment({
    required this.id,
    required this.title,
    required this.category,
    required this.score,
    required this.level,
    required this.signals,
    required this.assessedAt,
  });

  final String id;
  final String title;
  final String category;
  final int score;
  final RiskLevel level;
  final List<RiskSignal> signals;
  final DateTime assessedAt;
}
