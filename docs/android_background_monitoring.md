# Android Background Monitoring

CyberGuard uses `workmanager` for Android-compatible periodic background app scanning. The task is intentionally lightweight:

- Default cadence: every 6 hours.
- Android minimum cadence is respected: never below 15 minutes.
- Battery-friendly constraint: runs only when the battery is not low.
- Network is not required.
- Notifications are only shown when High or Critical app risk is found.

## Flutter Setup

The Flutter-side implementation lives in:

- `lib/core/background/background_monitoring_service.dart`
- `lib/core/background/background_monitoring_callback.dart`
- `lib/core/background/background_app_risk_monitor.dart`
- `lib/core/background/background_alert_service.dart`

`main.dart` initializes WorkManager and registers the periodic scan.
The WorkManager callback calls `DartPluginRegistrant.ensureInitialized()` so plugins are available inside the Android background isolate.

## Android Platform Notes

After generating Android platform files with:

```bash
flutter create . --platforms=android
```

verify these platform requirements:

1. Android 13+ notification permission:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

2. The `workmanager` plugin will merge its required receiver/service declarations through the manifest merger. Keep manifest merging enabled.

3. Do not request exact alarms for this feature. Periodic cybersecurity checks should use WorkManager so Android can batch work efficiently.

4. Keep scan work short. The background task should read app metadata, calculate risk, alert if needed, and exit.

5. Keep the callback top-level and annotated with `@pragma('vm:entry-point')`; Android background execution relies on this entry point surviving tree shaking.

## Best Practices Followed

- Uses WorkManager instead of long-running background services.
- Avoids wake locks and exact alarms.
- Uses a conservative 6-hour frequency.
- Requires battery not low.
- Performs local analysis only; no network dependency.
- Sends user-visible notifications only for actionable high-risk findings.
- Keeps background-isolate code minimal and delegates scanning to `BackgroundAppRiskMonitor`.
