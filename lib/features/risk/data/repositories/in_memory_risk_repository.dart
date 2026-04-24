import '../../../../core/services/risk_scoring_engine.dart';
import '../../domain/entities/risk_assessment.dart';
import '../../domain/repositories/risk_repository.dart';

class InMemoryRiskRepository implements RiskRepository {
  InMemoryRiskRepository(this._engine);

  final RiskScoringEngine _engine;
  final List<RiskAssessment> _assessments = [
    RiskAssessment(
      id: 'baseline',
      title: 'Device baseline',
      category: 'System',
      score: 22,
      level: const RiskScoringEngine().classify(22),
      signals: const [],
      assessedAt: DateTime(2026, 4, 23, 9),
    ),
  ];

  @override
  Future<void> clear() async {
    _assessments.clear();
  }

  @override
  Future<List<RiskAssessment>> getAssessments() async {
    final sorted = [..._assessments]
      ..sort((a, b) => b.assessedAt.compareTo(a.assessedAt));
    return sorted;
  }

  @override
  Future<RiskAssessment?> getLatestAssessment() async {
    final assessments = await getAssessments();
    if (assessments.isEmpty) {
      return null;
    }
    return assessments.first;
  }

  @override
  Future<void> saveAssessment(RiskAssessment assessment) async {
    _assessments.removeWhere((item) => item.id == assessment.id);
    _assessments.add(
      RiskAssessment(
        id: assessment.id,
        title: assessment.title,
        category: assessment.category,
        score: assessment.score,
        level: _engine.classify(assessment.score),
        signals: assessment.signals,
        assessedAt: assessment.assessedAt,
      ),
    );
  }
}
