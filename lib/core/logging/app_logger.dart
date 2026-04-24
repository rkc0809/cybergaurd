import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      debugPrint('[CyberGuard][warning] $message');
      if (error != null) {
        debugPrint('  error: $error');
      }
      if (stackTrace != null) {
        debugPrint('  stackTrace: $stackTrace');
      }
    }
  }

  static void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      debugPrint('[CyberGuard][fatal] $message');
      if (error != null) {
        debugPrint('  error: $error');
      }
      if (stackTrace != null) {
        debugPrint('  stackTrace: $stackTrace');
      }
    }
  }
}
