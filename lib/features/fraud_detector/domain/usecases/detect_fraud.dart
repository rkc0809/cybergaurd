import '../entities/fraud_detection_result.dart';
import '../repositories/fraud_detector_repository.dart';

class DetectFraud {
  const DetectFraud(this.repository);

  final FraudDetectorRepository repository;

  Future<FraudDetectionResult> call(String input) => repository.inspectMessageOrUrl(input);
}
