import '../entities/installed_app.dart';

abstract interface class AppScannerRepository {
  Future<List<InstalledApp>> scanInstalledApps();
}
