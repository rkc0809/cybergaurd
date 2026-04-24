import '../entities/fraud_detection_result.dart';

abstract interface class FraudDetectorRepository {
  Future<FraudDetectionResult> inspectMessageOrUrl(String input);
}
