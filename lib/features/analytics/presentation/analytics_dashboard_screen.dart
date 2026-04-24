import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_shell.dart';
import '../../../shared/widgets/cyber_button.dart';
import '../../../shared/widgets/security_card.dart';
import '../../../shared/widgets/section_header.dart';
import 'analytics_dashboard_view_model.dart';
import 'widgets/analytics_summary_card.dart';
import 'widgets/risk_distribution_chart.dart';

class AnalyticsDashboardScreen extends StatelessWidget {
  const AnalyticsDashboardScreen({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsDashboardViewModel(
        dependencies.appScannerService,
      )..load(),
      child: const _AnalyticsDashboardView(),
    );
  }
}

class _AnalyticsDashboardView extends StatelessWidget {
  const _AnalyticsDashboardView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AnalyticsDashboardViewModel>();

    return AppShell(
      title: 'Analytics',
      selectedIndex: 1,
      child: RefreshIndicator(
        onRefresh: viewModel.load,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;

            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: isWide ? AppSpacing.xl : AppSpacing.pagePadding,
                vertical: AppSpacing.pagePadding,
              ),
              children: [
                const SectionHeader(
                  title: 'Risk Analytics',
                  subtitle: 'Distribution of scanned applications by risk category.',
                ),
                const SizedBox(height: AppSpacing.lg),
                _SummaryGrid(viewModel: viewModel),
                const SizedBox(height: AppSpacing.lg),
                SecurityCard(
                  accentColor: AppColors.neonBlue,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Risk Distribution',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          if (viewModel.isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      RiskDistributionChart(
                        counts: viewModel.categoryCounts,
                        total: viewModel.totalAppsScanned,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                CyberButton(
                  label: 'Refresh Analytics',
                  icon: Icons.refresh,
                  variant: CyberButtonVariant.secondary,
                  isLoading: viewModel.isLoading,
                  onPressed: viewModel.load,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.viewModel});

  final AnalyticsDashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 640 ? 2 : 1;
        final width =
            (constraints.maxWidth - (AppSpacing.sm * (columns - 1))) / columns;

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            SizedBox(
              width: width,
              child: AnalyticsSummaryCard(
                label: 'Total apps scanned',
                value: viewModel.totalAppsScanned.toString(),
                icon: Icons.apps,
                accentColor: AppColors.neonGreen,
              ),
            ),
            SizedBox(
              width: width,
              child: AnalyticsSummaryCard(
                label: 'High-risk count',
                value: viewModel.highRiskCount.toString(),
                icon: Icons.report_gmailerrorred_outlined,
                accentColor: AppColors.neonRed,
              ),
            ),
          ],
        );
      },
    );
  }
}
