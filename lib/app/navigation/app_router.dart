import 'package:go_router/go_router.dart';

import '../../core/services/app_dependencies.dart';
import '../../features/analytics/presentation/analytics_dashboard_screen.dart';
import '../../features/app_scanner/presentation/app_scanner_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/file_analyzer/presentation/file_analyzer_screen.dart';
import '../../features/fraud_detector/presentation/fraud_detector_screen.dart';
import 'app_routes.dart';

GoRouter buildAppRouter(AppDependencies dependencies) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => DashboardScreen(dependencies: dependencies),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        builder: (context, state) => AnalyticsDashboardScreen(dependencies: dependencies),
      ),
      GoRoute(
        path: AppRoutes.appScanner,
        builder: (context, state) => AppScannerScreen(dependencies: dependencies),
      ),
      GoRoute(
        path: AppRoutes.fileAnalyzer,
        builder: (context, state) => FileAnalyzerScreen(dependencies: dependencies),
      ),
      GoRoute(
        path: AppRoutes.fraudDetector,
        builder: (context, state) => FraudDetectorScreen(dependencies: dependencies),
      ),
    ],
  );
}
