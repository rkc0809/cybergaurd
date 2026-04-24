import '../entities/file_threat_report.dart';
import '../repositories/file_analyzer_repository.dart';

class AnalyzeFile {
  const AnalyzeFile(this.repository);

  final FileAnalyzerRepository repository;

  Future<FileThreatReport> call({
    required String fileName,
    required String contentPreview,
    int fileSizeBytes = 0,
  }) {
    return repository.analyzeFile(
      fileName: fileName,
      contentPreview: contentPreview,
      fileSizeBytes: fileSizeBytes,
    );
  }
}
