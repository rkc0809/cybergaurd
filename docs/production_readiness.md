# Production Readiness Notes

CyberGuard is organized as a feature-first Flutter application with layered boundaries:

- `core`: app-wide services, models, background monitoring, logging, theme, and base classes.
- `features/*/domain`: entities, repository contracts, and use cases.
- `features/*/data`: local services and repository implementations.
- `features/*/presentation`: screens, view models, and feature widgets.
- `shared/widgets`: reusable UI components.

## Hardening Applied

- Startup is guarded with `runZonedGuarded`.
- Background monitoring failures are logged and do not block foreground app launch.
- Background work is WorkManager-based, periodic, and battery-aware.
- Risk scoring and impact prediction are deterministic and covered by tests.
- Fraud detection uses structured rules and weighted evidence.
- File scanning separates picker, metadata inspection, repository persistence, and UI.
- App scanning separates candidate collection, risk analysis, and repository aggregation.

## Production Follow-ups

- Replace simulated app scanning with platform-specific Android package metadata collection.
- Persist risk assessments in local storage instead of in-memory storage.
- Add user settings for enabling/disabling background monitoring.
- Add telemetry hooks behind explicit user consent.
- Add golden/widget tests once Flutter SDK is available in CI.
- Generate Android platform files and verify manifest permissions.

## Verification Commands

```bash
flutter pub get
flutter analyze
flutter test
```
