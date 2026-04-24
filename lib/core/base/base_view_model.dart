import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  @protected
  Future<void> runBusyTask(Future<void> Function() task) async {
    setLoading(true);
    clearError();
    try {
      await task();
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading(false);
    }
  }

  @protected
  void setLoading(bool value) {
    _isLoading = value;
    notifyIfAlive();
  }

  @protected
  void setError(String message) {
    _errorMessage = message;
    notifyIfAlive();
  }

  @protected
  void clearError() {
    _errorMessage = null;
    notifyIfAlive();
  }

  @protected
  void notifyIfAlive() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
