import '../../../core/base/base_view_model.dart';
import '../domain/entities/fraud_detection_result.dart';
import '../domain/usecases/detect_fraud.dart';

class FraudDetectorViewModel extends BaseViewModel {
  FraudDetectorViewModel(this._detectFraud);

  final DetectFraud _detectFraud;
  FraudDetectionResult? _result;

  FraudDetectionResult? get result => _result;

  Future<void> inspect(String input) async {
    await runBusyTask(() async {
      _result = await _detectFraud(input);
      notifyIfAlive();
    });
  }
}
