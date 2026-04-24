import '../entities/installed_app.dart';
import '../repositories/app_scanner_repository.dart';

class ScanInstalledApps {
  const ScanInstalledApps(this.repository);

  final AppScannerRepository repository;

  Future<List<InstalledApp>> call() => repository.scanInstalledApps();
}
