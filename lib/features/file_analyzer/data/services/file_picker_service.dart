import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<PickedThreatFile?> pickThreatFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: const [
        'pdf',
        'png',
        'jpg',
        'jpeg',
        'webp',
        'mp4',
        'mov',
        'avi',
        'mkv',
      ],
      withData: false,
    );

    final file = result?.files.single;
    if (file == null) {
      return null;
    }

    return PickedThreatFile(
      name: file.name,
      sizeBytes: file.size,
      extension: file.extension,
      path: file.path,
    );
  }
}

class PickedThreatFile {
  const PickedThreatFile({
    required this.name,
    required this.sizeBytes,
    this.extension,
    this.path,
  });

  final String name;
  final int sizeBytes;
  final String? extension;
  final String? path;

  String get metadataPreview {
    final extensionLabel = extension == null ? 'unknown' : extension!.toLowerCase();
    return 'Picked file metadata: extension=$extensionLabel sizeBytes=$sizeBytes path=${path ?? 'unavailable'}';
  }
}
