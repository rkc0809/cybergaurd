class RiskFactorWeights {
  const RiskFactorWeights({
    this.permissions = 0.3,
    this.behavior = 0.35,
    this.sourceTrust = 0.2,
    this.anomaly = 0.15,
  });

  final double permissions;
  final double behavior;
  final double sourceTrust;
  final double anomaly;

  double get total => permissions + behavior + sourceTrust + anomaly;
}
