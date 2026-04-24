import '../../../core/base/base_view_model.dart';
import '../domain/entities/installed_app.dart';
import '../domain/usecases/scan_installed_apps.dart';

class AppScannerViewModel extends BaseViewModel {
  AppScannerViewModel(this._scanInstalledApps);

  final ScanInstalledApps _scanInstalledApps;
  List<InstalledApp> _apps = [];

  List<InstalledApp> get apps => _apps;

  Future<void> scan() async {
    await runBusyTask(() async {
      _apps = await _scanInstalledApps();
      notifyIfAlive();
    });
  }
}
