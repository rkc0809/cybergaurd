import 'package:cyberguard/core/background/background_app_risk_monitor.dart';
import 'package:cyberguard/core/models/risk_level.dart';
import 'package:cyberguard/features/app_scanner/data/services/local_app_scanner_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('filters only high and critical app findings for alerts', () {
    final monitor = BackgroundAppRiskMonitor();

    final result = monitor.filterHighRiskApps(
      const [
        ScannedAppRisk(
          appName: 'Safe App',
          packageName: 'com.safe.app',
          permissions: [],
          riskScore: 8,
          findings: [],
        ),
        ScannedAppRisk(
          appName: 'Medium App',
          packageName: 'com.medium.app',
          permissions: [],
          riskScore: 42,
          findings: [],
        ),
        ScannedAppRisk(
          appName: 'High App',
          packageName: 'com.high.app',
          permissions: [],
          riskScore: 72,
          findings: [],
        ),
        ScannedAppRisk(
          appName: 'Critical App',
          packageName: 'com.critical.app',
          permissions: [],
          riskScore: 91,
          findings: [],
        ),
      ],
    );

    expect(result.map((app) => app.appName), ['High App', 'Critical App']);
  });
}
