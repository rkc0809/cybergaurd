import '../../../../core/models/risk_factor_input.dart';
import '../../../../core/models/risk_level.dart';
import '../../../../core/services/risk_scoring_engine.dart';

class LocalAppScannerService {
  LocalAppScannerService({
    RiskScoringEngine riskScoringEngine = const RiskScoringEngine(),
  }) : _riskScoringEngine = riskScoringEngine;

  final RiskScoringEngine _riskScoringEngine;

  Future<List<ScannedAppRisk>> scanInstalledApps() async {
    final candidates = await fetchInstalledApps();
    return candidates.map(analyzeInstalledApp).toList();
  }

  Future<List<InstalledAppCandidate>> fetchInstalledApps() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const [
      InstalledAppCandidate(
        packageName: 'com.chat.safe',
        appName: 'SafeChat',
        permissions: ['Internet', 'Contacts'],
        installSource: AppInstallSource.officialStore,
      ),
      InstalledAppCandidate(
        packageName: 'com.flashlight.freevpn',
        appName: 'Flash VPN Light',
        permissions: ['Internet', 'Location', 'SMS', 'Accessibility'],
        installSource: AppInstallSource.unknown,
      ),
      InstalledAppCandidate(
        packageName: 'com.bank.mobile',
        appName: 'Bank Mobile',
        permissions: ['Internet', 'Biometric'],
        installSource: AppInstallSource.officialStore,
      ),
      InstalledAppCandidate(
        packageName: 'apk.spy.cleaner.optim',
        appName: 'Cleaner Optimizer',
        permissions: ['Internet', 'Storage', 'Accessibility', 'NotificationAccess'],
        installSource: AppInstallSource.sideLoaded,
      ),
    ];
  }

  ScannedAppRisk analyzeInstalledApp(InstalledAppCandidate app) {
    final permissionFindings = _permissionFindings(app.permissions);
    final packageFindings = _packagePatternFindings(app.packageName);
    final behaviorFindings = _behaviorFindings(app);
    final findings = [
      ...permissionFindings,
      ...packageFindings,
      ...behaviorFindings,
    ];
    final result = _riskScoringEngine.evaluate(
      RiskFactorInput(
        permissionsRisk: _permissionRisk(app.permissions),
        behaviorRisk: _behaviorRisk(app, behaviorFindings),
        sourceTrustRisk: _sourceTrustRisk(app.installSource),
        anomalyRisk: _anomalyRisk(app, findings),
      ),
    );

    return ScannedAppRisk(
      appName: app.appName,
      packageName: app.packageName,
      permissions: app.permissions,
      riskScore: result.percentage,
      riskLevelOverride: result.category,
      findings: findings.isEmpty ? ['No elevated risk indicators detected'] : findings,
    );
  }

  List<String> _permissionFindings(List<String> permissions) {
    const riskyPermissions = {
      'SMS': 'Requests SMS access',
      'Accessibility': 'Requests accessibility control',
      'Location': 'Requests location access',
      'Storage': 'Requests broad storage access',
      'NotificationAccess': 'Can read notification content',
    };

    return permissions
        .where(riskyPermissions.containsKey)
        .map((permission) => riskyPermissions[permission]!)
        .toList();
  }

  List<String> _packagePatternFindings(String packageName) {
    final normalized = packageName.toLowerCase();
    final findings = <String>[];

    if (normalized.contains('freevpn') || normalized.contains('vpn')) {
      findings.add('Package name suggests traffic tunneling behavior');
    }
    if (normalized.startsWith('apk.') || normalized.contains('.spy.')) {
      findings.add('Package name resembles side-loaded or surveillance tooling');
    }
    if (normalized.contains('cleaner') || normalized.contains('optim')) {
      findings.add('Package name uses common utility-app lure terms');
    }

    return findings;
  }

  List<String> _behaviorFindings(InstalledAppCandidate app) {
    final findings = <String>[];
    final permissions = app.permissions.toSet();

    if (permissions.contains('Accessibility') && permissions.contains('SMS')) {
      findings.add('Could observe screen activity and intercept SMS codes');
    }
    if (permissions.contains('NotificationAccess') && permissions.contains('Internet')) {
      findings.add('Could exfiltrate notification content');
    }
    if (app.installSource == AppInstallSource.sideLoaded) {
      findings.add('Installed from outside the official app store');
    }

    return findings;
  }

  double _permissionRisk(List<String> permissions) {
    const highRiskPermissions = {
      'Accessibility',
      'SMS',
      'NotificationAccess',
      'Storage',
      'Location',
    };
    final riskyCount = permissions.where(highRiskPermissions.contains).length;
    return (riskyCount / highRiskPermissions.length).clamp(0, 1).toDouble();
  }

  double _behaviorRisk(InstalledAppCandidate app, List<String> behaviorFindings) {
    final packageName = app.packageName.toLowerCase();
    final baseRisk = behaviorFindings.length * 0.28;
    final patternRisk = packageName.contains('spy') || packageName.contains('freevpn') ? 0.32 : 0;
    return (baseRisk + patternRisk).clamp(0, 1).toDouble();
  }

  double _sourceTrustRisk(AppInstallSource source) {
    return switch (source) {
      AppInstallSource.officialStore => 0.12,
      AppInstallSource.enterpriseStore => 0.28,
      AppInstallSource.sideLoaded => 0.72,
      AppInstallSource.unknown => 0.82,
    };
  }

  double _anomalyRisk(InstalledAppCandidate app, List<String> findings) {
    final permissionVolumeRisk = app.permissions.length > 3 ? 0.28 : 0.08;
    final findingVolumeRisk = findings.length >= 4 ? 0.55 : findings.length * 0.1;
    return (permissionVolumeRisk + findingVolumeRisk).clamp(0, 1).toDouble();
  }
}

class InstalledAppCandidate {
  const InstalledAppCandidate({
    required this.packageName,
    required this.appName,
    required this.permissions,
    required this.installSource,
  });

  final String packageName;
  final String appName;
  final List<String> permissions;
  final AppInstallSource installSource;
}

class ScannedAppRisk {
  const ScannedAppRisk({
    required this.appName,
    required this.packageName,
    required this.permissions,
    required this.riskScore,
    this.riskLevelOverride,
    this.riskCategory,
    required this.findings,
  });

  final String appName;
  final String packageName;
  final List<String> permissions;
  final int riskScore;
  final RiskLevel? riskLevelOverride;
  @Deprecated('Use riskLevel instead.')
  final RiskLevel? riskCategory;
  final List<String> findings;

  RiskLevel get riskLevel => riskLevelOverride ?? riskCategory ?? RiskLevel.fromScore(riskScore);
}

enum AppInstallSource {
  officialStore,
  enterpriseStore,
  sideLoaded,
  unknown,
}
