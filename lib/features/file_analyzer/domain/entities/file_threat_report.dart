import '../../../../core/models/risk_level.dart';

class FileThreatReport {
  const FileThreatReport({
    required this.fileName,
    required this.fileType,
    required this.fileSizeBytes,
    required this.sha256,
    required this.score,
    required this.level,
    required this.indicators,
    required this.recommendation,
  });

  final String fileName;
  final String fileType;
  final int fileSizeBytes;
  final String sha256;
  final int score;
  final RiskLevel level;
  final List<String> indicators;
  final String recommendation;
}
