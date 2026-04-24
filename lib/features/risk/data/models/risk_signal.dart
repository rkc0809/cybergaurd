class RiskSignal {
  const RiskSignal({
    required this.source,
    required this.title,
    required this.description,
    required this.severity,
    required this.confidence,
    this.weight = 1,
  });

  final String source;
  final String title;
  final String description;
  final double severity;
  final double confidence;
  final double weight;
}
