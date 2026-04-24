import '../entities/file_threat_report.dart';

abstract interface class FileAnalyzerRepository {
  Future<FileThreatReport> analyzeFile({
    required String fileName,
    required String contentPreview,
    int fileSizeBytes = 0,
  });
}
