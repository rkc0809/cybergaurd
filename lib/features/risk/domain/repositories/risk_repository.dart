import '../entities/risk_assessment.dart';

abstract interface class RiskRepository {
  Future<List<RiskAssessment>> getAssessments();
  Future<RiskAssessment?> getLatestAssessment();
  Future<void> saveAssessment(RiskAssessment assessment);
  Future<void> clear();
}
