import '../../../../core/models/risk_level.dart';

class InstalledApp {
  const InstalledApp({
    required this.packageName,
    required this.displayName,
    required this.permissions,
    required this.riskScore,
    required this.riskLevel,
    required this.findings,
  });

  final String packageName;
  final String displayName;
  final List<String> permissions;
  final int riskScore;
  final RiskLevel riskLevel;
  final List<String> findings;
}
