class LocalFileThreatService {
  Future<FileThreatSignals> inspect({
    required String fileName,
    required String contentPreview,
    required int fileSizeBytes,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final normalized = '${fileName.toLowerCase()} ${contentPreview.toLowerCase()}';
    final indicators = <String>[];

    if (normalized.contains('.exe') || normalized.contains('.scr')) {
      indicators.add('Executable file extension');
    }
    if (normalized.contains('powershell') || normalized.contains('cmd.exe')) {
      indicators.add('Command execution pattern');
    }
    if (normalized.contains('base64') || normalized.contains('frombase64string')) {
      indicators.add('Encoded payload indicator');
    }
    if (normalized.contains('invoice') && normalized.contains('macro')) {
      indicators.add('Social engineering macro lure');
    }
    if (_isSuspiciousExtension(fileName)) {
      indicators.add('Suspicious extension for supported file scan');
    }
    if (_hasSizeAnomaly(fileName, fileSizeBytes)) {
      indicators.add('File size anomaly');
    }

    return FileThreatSignals(
      fileType: fileName.contains('.') ? fileName.split('.').last.toUpperCase() : 'UNKNOWN',
      sizeBytes: fileSizeBytes,
      indicators: indicators,
    );
  }

  bool _isSuspiciousExtension(String fileName) {
    final normalized = fileName.toLowerCase();
    return normalized.endsWith('.exe') ||
        normalized.endsWith('.scr') ||
        normalized.endsWith('.js') ||
        normalized.endsWith('.vbs') ||
        normalized.endsWith('.apk');
  }

  bool _hasSizeAnomaly(String fileName, int fileSizeBytes) {
    if (fileSizeBytes <= 0) {
      return false;
    }

    final normalized = fileName.toLowerCase();
    final sizeMb = fileSizeBytes / (1024 * 1024);
    if (normalized.endsWith('.pdf')) {
      return sizeMb > 60 || sizeMb < 0.01;
    }
    if (normalized.endsWith('.png') ||
        normalized.endsWith('.jpg') ||
        normalized.endsWith('.jpeg') ||
        normalized.endsWith('.webp')) {
      return sizeMb > 35 || sizeMb < 0.005;
    }
    if (normalized.endsWith('.mp4') ||
        normalized.endsWith('.mov') ||
        normalized.endsWith('.avi') ||
        normalized.endsWith('.mkv')) {
      return sizeMb > 2500 || sizeMb < 0.05;
    }
    return sizeMb > 100;
  }
}

class FileThreatSignals {
  const FileThreatSignals({
    required this.fileType,
    required this.sizeBytes,
    required this.indicators,
  });

  final String fileType;
  final int sizeBytes;
  final List<String> indicators;
}
