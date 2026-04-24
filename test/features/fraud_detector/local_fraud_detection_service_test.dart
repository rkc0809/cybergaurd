import 'package:cyberguard/features/fraud_detector/data/services/local_fraud_detection_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalFraudDetectionService', () {
    test('detects common phishing patterns with structured probability', () async {
      final service = LocalFraudDetectionService();

      final analysis = await service.analyze(
        'Urgent: your bank account is locked. Verify password at http://bit.ly/refund',
      );
      final matches = analysis.evidence.map((item) => item.label);

      expect(matches, contains('Urgency pressure'));
      expect(matches, contains('Credential harvesting language'));
      expect(matches, contains('Unencrypted link'));
      expect(matches, contains('Shortened URL'));
      expect(matches, contains('Financial lure'));
      expect(matches, contains('Account lock scare tactic'));
      expect(analysis.probability, greaterThanOrEqualTo(85));
      expect(analysis.warningMessage, contains('Critical fraud risk'));
    });

    test('returns low probability for clean input', () async {
      final service = LocalFraudDetectionService();

      final analysis = await service.analyze('Team lunch is moved to 1 PM today.');

      expect(analysis.probability, lessThan(10));
      expect(analysis.evidence, isEmpty);
      expect(analysis.predictedImpact, 'No immediate impact predicted');
    });
  });
}
