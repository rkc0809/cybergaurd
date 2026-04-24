class RiskFactorInput {
  const RiskFactorInput({
    required this.permissionsRisk,
    required this.behaviorRisk,
    required this.sourceTrustRisk,
    required this.anomalyRisk,
  });

  final double permissionsRisk;
  final double behaviorRisk;
  final double sourceTrustRisk;
  final double anomalyRisk;

  factory RiskFactorInput.safe() {
    return const RiskFactorInput(
      permissionsRisk: 0,
      behaviorRisk: 0,
      sourceTrustRisk: 0,
      anomalyRisk: 0,
    );
  }
}
