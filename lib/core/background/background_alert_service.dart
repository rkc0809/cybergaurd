import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/app_scanner/data/services/local_app_scanner_service.dart';
import '../models/risk_level.dart';
import 'background_monitoring_config.dart';

class BackgroundAlertService {
  BackgroundAlertService({
    FlutterLocalNotificationsPlugin? notificationsPlugin,
  }) : _notificationsPlugin = notificationsPlugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
    await _createAndroidChannel();
  }

  Future<void> requestAndroidNotificationPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> showHighRiskAppsAlert(List<ScannedAppRisk> riskyApps) async {
    if (riskyApps.isEmpty) {
      return;
    }

    final criticalCount =
        riskyApps.where((app) => app.riskLevel == RiskLevel.critical).length;
    final title = criticalCount > 0
        ? 'Critical app risk detected'
        : 'High-risk app detected';
    final topApp = [...riskyApps]..sort((a, b) => b.riskScore.compareTo(a.riskScore));
    final body = topApp.length == 1
        ? '${topApp.first.appName} scored ${topApp.first.riskScore}%.'
        : '${topApp.first.appName} and ${topApp.length - 1} more apps need review.';

    await _notificationsPlugin.show(
      1001,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          BackgroundMonitoringConfig.notificationChannelId,
          BackgroundMonitoringConfig.notificationChannelName,
          channelDescription: BackgroundMonitoringConfig.notificationChannelDescription,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.status,
          onlyAlertOnce: true,
        ),
      ),
    );
  }

  Future<void> _createAndroidChannel() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        BackgroundMonitoringConfig.notificationChannelId,
        BackgroundMonitoringConfig.notificationChannelName,
        description: BackgroundMonitoringConfig.notificationChannelDescription,
        importance: Importance.high,
      ),
    );
  }
}
