import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/risk_colors.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/cyber_button.dart';
import '../../../shared/widgets/risk_indicator.dart';
import '../../../shared/widgets/security_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../domain/usecases/analyze_file.dart';
import 'file_analyzer_view_model.dart';

class FileAnalyzerScreen extends StatefulWidget {
  const FileAnalyzerScreen({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<FileAnalyzerScreen> createState() => _FileAnalyzerScreenState();
}

class _FileAnalyzerScreenState extends State<FileAnalyzerScreen> {
  final _fileNameController = TextEditingController(text: 'invoice_macro.docm');
  final _previewController = TextEditingController(
    text: 'Invoice macro launches powershell with base64 payload',
  );

  @override
  void dispose() {
    _fileNameController.dispose();
    _previewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FileAnalyzerViewModel(
        AnalyzeFile(widget.dependencies.fileAnalyzerRepository),
      ),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<FileAnalyzerViewModel>();
          final report = viewModel.report;

          return AppShell(
            title: 'File Threat Analyzer',
            selectedIndex: 3,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              children: [
                const SectionHeader(
                  title: 'File Threat Analyzer',
                  subtitle: 'Pick a PDF, image, or video and scan metadata for risk indicators.',
                ),
                const SizedBox(height: AppSpacing.md),
                SecurityCard(
                  accentColor: AppColors.neonBlue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fast file scan', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Checks file type, size anomalies, suspicious extensions, and metadata signals.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      CyberButton(
                        label: 'Pick File',
                        icon: Icons.upload_file,
                        isLoading: viewModel.isLoading,
                        onPressed: () {
                          viewModel.pickAndAnalyzeFile();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _fileNameController,
                  decoration: const InputDecoration(
                    labelText: 'Manual file name fallback',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: _previewController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Manual metadata fallback',
                    prefixIcon: Icon(Icons.manage_search),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CyberButton(
                  label: 'Analyze File',
                  icon: Icons.policy,
                  isLoading: viewModel.isLoading,
                  onPressed: () => viewModel.analyze(
                    fileName: _fileNameController.text,
                    contentPreview: _previewController.text,
                  ),
                ),
                if (report != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  SecurityCard(
                    accentColor: RiskColors.accentFor(report.level),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                report.fileName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            RiskIndicator(level: report.level, score: report.score),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _MetadataRow(label: 'Type', value: report.fileType),
                        _MetadataRow(label: 'Size', value: _formatBytes(report.fileSizeBytes)),
                        _MetadataRow(
                          label: 'SHA-256',
                          value: '${report.sha256.substring(0, 18)}...',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (final indicator in report.indicators)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.warning_amber_outlined),
                            title: Text(indicator),
                          ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(report.recommendation),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) {
      return 'Unknown';
    }

    const kb = 1024;
    const mb = kb * 1024;
    const gb = mb * 1024;
    if (bytes >= gb) {
      return '${(bytes / gb).toStringAsFixed(2)} GB';
    }
    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(2)} MB';
    }
    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
