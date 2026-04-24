import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/navigation/app_routes.dart';
import '../../../core/services/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/quick_action_card.dart';
import '../../../shared/widgets/section_header.dart';
import 'dashboard_view_model.dart';
import 'widgets/risk_summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(
        riskRepository: dependencies.riskRepository,
        appScannerRepository: dependencies.appScannerRepository,
      )..load(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return AppShell(
      title: 'CyberGuard',
      selectedIndex: 0,
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: viewModel.load,
          icon: const Icon(Icons.refresh),
        ),
      ],
      child: RefreshIndicator(
        onRefresh: viewModel.load,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;

            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? AppSpacing.xl : AppSpacing.pagePadding,
                vertical: AppSpacing.pagePadding,
              ),
              children: [
                const _HomeHeader(),
                const SizedBox(height: AppSpacing.lg),
                _QuickActionsGrid(
                  isLoading: viewModel.isLoading,
                  onRunFullScan: () {
                    viewModel.runFullScan();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                RiskSummaryCard(
                  latestAssessment: viewModel.latestAssessment,
                  averageScore: viewModel.averageScore,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return const SectionHeader(
      title: 'CyberGuard',
      subtitle: 'Mobile cybersecurity intelligence, scans, and risk posture in one place.',
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.isLoading,
    required this.onRunFullScan,
  });

  final bool isLoading;
  final VoidCallback onRunFullScan;

  @override
  Widget build(BuildContext context) {
    final actions = [
      QuickActionCard(
        title: 'Run Full Scan',
        subtitle: 'Apps and device posture',
        icon: Icons.security,
        accentColor: AppColors.neonGreen,
        isLoading: isLoading,
        onTap: onRunFullScan,
      ),
      QuickActionCard(
        title: 'Scan Files',
        subtitle: 'Inspect file indicators',
        icon: Icons.description_outlined,
        accentColor: AppColors.neonBlue,
        onTap: () => context.go(AppRoutes.fileAnalyzer),
      ),
      QuickActionCard(
        title: 'Analyze Message',
        subtitle: 'Detect fraud and phishing',
        icon: Icons.sms_failed_outlined,
        accentColor: AppColors.neonRed,
        onTap: () => context.go(AppRoutes.fraudDetector),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 560
                ? 2
                : 1;
        final itemWidth =
            (constraints.maxWidth - (AppSpacing.sm * (columns - 1))) / columns;

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final action in actions)
              SizedBox(
                width: itemWidth,
                child: action,
              ),
          ],
        );
      },
    );
  }
}
