import 'package:cyberguard/core/models/risk_level.dart';
import 'package:cyberguard/features/app_scanner/data/services/local_app_scanner_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalAppScannerService', () {
    test('returns structured scanned app risk data', () async {
      final service = LocalAppScannerService();

      final apps = await service.scanInstalledApps();

      expect(apps, isNotEmpty);
      expect(apps.first.appName, isNotEmpty);
      expect(apps.first.riskScore, inInclusiveRange(0, 100));
      expect(apps.first.riskLevel, isA<RiskLevel>());
    });

    test('scores unknown VPN app higher than official store banking app', () {
      final service = LocalAppScannerService();

      final riskyApp = service.analyzeInstalledApp(
        const InstalledAppCandidate(
          packageName: 'com.flashlight.freevpn',
          appName: 'Flash VPN Light',
          permissions: ['Internet', 'Location', 'SMS', 'Accessibility'],
          installSource: AppInstallSource.unknown,
        ),
      );
      final trustedApp = service.analyzeInstalledApp(
        const InstalledAppCandidate(
          packageName: 'com.bank.mobile',
          appName: 'Bank Mobile',
          permissions: ['Internet', 'Biometric'],
          installSource: AppInstallSource.officialStore,
        ),
      );

      expect(riskyApp.riskScore, greaterThan(trustedApp.riskScore));
      expect(riskyApp.findings, contains('Requests SMS access'));
      expect(riskyApp.findings, contains('Requests accessibility control'));
      expect(riskyApp.findings, contains('Package name suggests traffic tunneling behavior'));
    });

    test('detects side-loaded surveillance and notification exfiltration assumptions', () {
      final service = LocalAppScannerService();

      final result = service.analyzeInstalledApp(
        const InstalledAppCandidate(
          packageName: 'apk.spy.cleaner.optim',
          appName: 'Cleaner Optimizer',
          permissions: ['Internet', 'Storage', 'Accessibility', 'NotificationAccess'],
          installSource: AppInstallSource.sideLoaded,
        ),
      );

      expect(result.riskScore, greaterThanOrEqualTo(60));
      expect(result.riskLevel, anyOf(RiskLevel.high, RiskLevel.critical));
      expect(result.findings, contains('Can read notification content'));
      expect(result.findings, contains('Installed from outside the official app store'));
    });
  });
}
