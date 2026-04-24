import 'package:cyberguard/features/file_analyzer/data/services/local_file_threat_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalFileThreatService', () {
    test('detects pdf file type without false positives', () async {
      final service = LocalFileThreatService();

      final result = await service.inspect(
        fileName: 'report.pdf',
        contentPreview: 'Quarterly report metadata',
        fileSizeBytes: 2 * 1024 * 1024,
      );

      expect(result.fileType, 'PDF');
      expect(result.sizeBytes, 2 * 1024 * 1024);
      expect(result.indicators, isEmpty);
    });

    test('detects image size anomaly', () async {
      final service = LocalFileThreatService();

      final result = await service.inspect(
        fileName: 'profile.jpg',
        contentPreview: 'image metadata',
        fileSizeBytes: 42 * 1024 * 1024,
      );

      expect(result.indicators, contains('File size anomaly'));
    });

    test('detects suspicious extension and command indicators', () async {
      final service = LocalFileThreatService();

      final result = await service.inspect(
        fileName: 'invoice.pdf.exe',
        contentPreview: 'launches powershell with base64 payload',
        fileSizeBytes: 900 * 1024,
      );

      expect(result.indicators, contains('Executable file extension'));
      expect(result.indicators, contains('Suspicious extension for supported file scan'));
      expect(result.indicators, contains('Command execution pattern'));
      expect(result.indicators, contains('Encoded payload indicator'));
    });
  });
}
