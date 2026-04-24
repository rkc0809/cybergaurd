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
import '../domain/usecases/scan_installed_apps.dart';
import 'app_scanner_view_model.dart';

class AppScannerScreen extends StatelessWidget {
  const AppScannerScreen({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppScannerViewModel(
        ScanInstalledApps(dependencies.appScannerRepository),
      ),
      child: const _AppScannerView(),
    );
  }
}

class _AppScannerView extends StatelessWidget {
  const _AppScannerView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AppScannerViewModel>();

    return AppShell(
      title: 'App Risk Scanner',
      selectedIndex: 2,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          const SectionHeader(
            title: 'Installed App Review',
            subtitle: 'Assess permissions and behavior indicators for risky apps.',
          ),
          const SizedBox(height: AppSpacing.md),
          CyberButton(
            label: 'Run App Scan',
            icon: Icons.security,
            isLoading: viewModel.isLoading,
            onPressed: viewModel.scan,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final app in viewModel.apps) ...[
            SecurityCard(
              accentColor: RiskColors.accentFor(app.riskLevel),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          app.displayName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      RiskIndicator(level: app.riskLevel, score: app.riskScore),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    app.packageName,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final permission in app.permissions)
                        Chip(
                          avatar: const Icon(Icons.key, size: 16, color: AppColors.neonBlue),
                          label: Text(permission),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  for (final finding in app.findings)
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.info_outline),
                      title: Text(finding),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
