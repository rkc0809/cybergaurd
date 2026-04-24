enum RiskLevel {
  low('Low', 0, 30),
  medium('Medium', 31, 60),
  high('High', 61, 80),
  critical('Critical', 81, 100);

  const RiskLevel(this.label, this.minScore, this.maxScore);

  final String label;
  final int minScore;
  final int maxScore;

  static RiskLevel fromScore(int score) {
    final clamped = score.clamp(0, 100);
    return RiskLevel.values.firstWhere(
      (level) => clamped >= level.minScore && clamped <= level.maxScore,
    );
  }
}