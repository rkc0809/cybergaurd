import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_dependencies.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/risk_colors.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/cyber_button.dart';
import '../../../shared/widgets/risk_indicator.dart';
import '../../../shared/widgets/security_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../domain/usecases/detect_fraud.dart';
import 'fraud_detector_view_model.dart';

class FraudDetectorScreen extends StatefulWidget {
  const FraudDetectorScreen({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  State<FraudDetectorScreen> createState() => _FraudDetectorScreenState();
}

class _FraudDetectorScreenState extends State<FraudDetectorScreen> {
  final _messageController = TextEditingController(
    text: 'Urgent: your bank account is locked. Verify password at http://bit.ly/refund',
  );

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FraudDetectorViewModel(
        DetectFraud(widget.dependencies.fraudDetectorRepository),
      ),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<FraudDetectorViewModel>();
          final result = viewModel.result;

          return AppShell(
            title: 'Fraud Detector',
            selectedIndex: 4,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              children: [
                const SectionHeader(
                  title: 'Message and URL Review',
                  subtitle: 'Detect phishing, scams, and suspicious links before tapping.',
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _messageController,
                  minLines: 4,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'Message or URL',
                    prefixIcon: Icon(Icons.sms_failed_outlined),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                CyberButton(
                  label: 'Detect Fraud',
                  icon: Icons.travel_explore,
                  variant: CyberButtonVariant.danger,
                  isLoading: viewModel.isLoading,
                  onPressed: () => viewModel.inspect(_messageController.text),
                ),
                if (result != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  SecurityCard(
                    accentColor: RiskColors.accentFor(result.level),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Fraud assessment',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            RiskIndicator(level: result.level, score: result.score),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (final match in result.matches)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.report_gmailerrorred_outlined),
                            title: Text(match),
                          ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(result.warningMessage),
                        const SizedBox(height: AppSpacing.sm),
                        _ImpactRow(
                          label: 'Probability',
                          value: '${result.fraudProbability}%',
                        ),
                        _ImpactRow(
                          label: 'Impact',
                          value: result.predictedImpact,
                        ),
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
}

class _ImpactRow extends StatelessWidget {
  const _ImpactRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
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
