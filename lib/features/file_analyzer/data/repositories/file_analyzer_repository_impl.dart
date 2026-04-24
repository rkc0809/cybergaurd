import 'dart:convert';

import '../../../../core/models/risk_factor_input.dart';
import '../../../../core/services/risk_scoring_engine.dart';
import '../../../risk/data/models/risk_signal.dart';
import '../../../risk/domain/entities/risk_assessment.dart';
import '../../../risk/domain/repositories/risk_repository.dart';
import '../../domain/entities/file_threat_report.dart';
import '../../domain/repositories/file_analyzer_repository.dart';
import '../services/local_file_threat_service.dart';

class FileAnalyzerRepositoryImpl implements FileAnalyzerRepository {
  FileAnalyzerRepositoryImpl({
    required LocalFileThreatService service,
    required RiskRepository riskRepository,
  })  : _service = service,
        _riskRepository = riskRepository,
        _engine = RiskScoringEngine();

  final LocalFileThreatService _service;
  final RiskRepository _riskRepository;
  final RiskScoringEngine _engine;

  @override
  Future<FileThreatReport> analyzeFile({
    required String fileName,
    required String contentPreview,
    int fileSizeBytes = 0,
  }) async {
    final threatSignals = await _service.inspect(
      fileName: fileName,
      contentPreview: contentPreview,
      fileSizeBytes: fileSizeBytes,
    );
    final signals = threatSignals.indicators.map((indicator) {
      return RiskSignal(
        source: fileName,
        title: indicator,
        description: 'Static inspection matched $indicator.',
        severity: _severityFor(indicator),
        confidence: 0.76,
        weight: 1.2,
      );
    }).toList();
    final score = _engine
        .evaluate(
          RiskFactorInput(
            permissionsRisk: _extensionRisk(fileName),
            behaviorRisk: _average(signals.map((signal) => signal.severity)),
            sourceTrustRisk: _sourceTrustRisk(fileName),
            anomalyRisk: _anomalyRisk(threatSignals),
          ),
        )
        .percentage;
    final level = _engine.classify(score);
    final report = FileThreatReport(
      fileName: fileName,
      fileType: threatSignals.fileType,
      fileSizeBytes: threatSignals.sizeBytes,
      sha256: _pseudoSha256('$fileName:$contentPreview'),
      score: score,
      level: level,
      indicators: threatSignals.indicators.isEmpty
          ? ['No known malicious indicators found']
          : threatSignals.indicators,
      recommendation: score >= 75
          ? 'Quarantine and submit to a malware sandbox.'
          : score >= 50
              ? 'Open only in an isolated environment.'
              : 'File appears low risk based on local heuristics.',
    );

    await _riskRepository.saveAssessment(
      RiskAssessment(
        id: 'file-${DateTime.now().millisecondsSinceEpoch}',
        title: 'File threat analysis',
        category: 'Files',
        score: report.score,
        level: report.level,
        signals: signals,
        assessedAt: DateTime.now(),
      ),
    );

    return report;
  }

  double _severityFor(String indicator) {
    return switch (indicator) {
      'File size anomaly' => 0.78,
      'Suspicious extension for supported file scan' => 0.86,
      'Encoded payload indicator' => 0.88,
      'Command execution pattern' => 0.82,
      'Executable file extension' => 0.64,
      _ => 0.56,
    };
  }

  double _extensionRisk(String fileName) {
    final normalized = fileName.toLowerCase();
    if (normalized.endsWith('.exe') || normalized.endsWith('.scr')) {
      return 0.9;
    }
    if (normalized.endsWith('.js') ||
        normalized.endsWith('.vbs') ||
        normalized.endsWith('.apk')) {
      return 0.84;
    }
    if (normalized.endsWith('.docm') || normalized.endsWith('.xlsm')) {
      return 0.68;
    }
    if (_isSupportedMediaOrDocument(normalized)) {
      return 0.08;
    }
    return 0.18;
  }

  double _sourceTrustRisk(String fileName) {
    final normalized = fileName.toLowerCase();
    if (normalized.contains('invoice') || normalized.contains('refund')) {
      return 0.58;
    }
    return 0.25;
  }

  double _anomalyRisk(FileThreatSignals threatSignals) {
    final indicatorRisk = threatSignals.indicators.length >= 3
        ? 0.82
        : threatSignals.indicators.length * 0.24;
    final sizeRisk = threatSignals.indicators.contains('File size anomaly') ? 0.38 : 0;
    return (indicatorRisk + sizeRisk).clamp(0, 1).toDouble();
  }

  bool _isSupportedMediaOrDocument(String fileName) {
    return fileName.endsWith('.pdf') ||
        fileName.endsWith('.png') ||
        fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg') ||
        fileName.endsWith('.webp') ||
        fileName.endsWith('.mp4') ||
        fileName.endsWith('.mov') ||
        fileName.endsWith('.avi') ||
        fileName.endsWith('.mkv');
  }

  double _average(Iterable<double> values) {
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((sum, value) => sum + value) / values.length;
  }

  String _pseudoSha256(String value) {
    final bytes = utf8.encode(value);
    final digest = bytes.fold<int>(17, (hash, byte) => 31 * hash + byte);
    return digest.abs().toRadixString(16).padLeft(64, '0').substring(0, 64);
  }
}
