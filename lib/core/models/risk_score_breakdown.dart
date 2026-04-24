class RiskScoreBreakdown {
  const RiskScoreBreakdown({
    required this.permissionsContribution,
    required this.behaviorContribution,
    required this.sourceTrustContribution,
    required this.anomalyContribution,
  });

  final double permissionsContribution;
  final double behaviorContribution;
  final double sourceTrustContribution;
  final double anomalyContribution;

  double get total =>
      permissionsContribution +
      behaviorContribution +
      sourceTrustContribution +
      anomalyContribution;
}
