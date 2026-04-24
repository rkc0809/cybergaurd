import '../../../core/base/base_view_model.dart';
import '../data/services/file_picker_service.dart';
import '../domain/entities/file_threat_report.dart';
import '../domain/usecases/analyze_file.dart';

class FileAnalyzerViewModel extends BaseViewModel {
  FileAnalyzerViewModel(
    this._analyzeFile, {
    FilePickerService? filePickerService,
  }) : _filePickerService = filePickerService ?? FilePickerService();

  final AnalyzeFile _analyzeFile;
  final FilePickerService _filePickerService;
  FileThreatReport? _report;
  PickedThreatFile? _selectedFile;

  FileThreatReport? get report => _report;
  PickedThreatFile? get selectedFile => _selectedFile;

  Future<void> analyze({
    required String fileName,
    required String contentPreview,
    int fileSizeBytes = 0,
  }) async {
    await runBusyTask(() async {
      _report = await _analyzeFile(
        fileName: fileName,
        contentPreview: contentPreview,
        fileSizeBytes: fileSizeBytes,
      );
      notifyIfAlive();
    });
  }

  Future<void> pickAndAnalyzeFile() async {
    await runBusyTask(() async {
      final pickedFile = await _filePickerService.pickThreatFile();
      if (pickedFile == null) {
        return;
      }

      _selectedFile = pickedFile;
      _report = await _analyzeFile(
        fileName: pickedFile.name,
        contentPreview: pickedFile.metadataPreview,
        fileSizeBytes: pickedFile.sizeBytes,
      );
      notifyIfAlive();
    });
  }
}
