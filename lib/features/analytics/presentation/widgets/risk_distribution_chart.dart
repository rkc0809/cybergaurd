import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/models/risk_level.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/risk_colors.dart';

class RiskDistributionChart extends StatelessWidget {
  const RiskDistributionChart({
    required this.counts,
    required this.total,
    super.key,
  });

  final Map<RiskLevel, int> counts;
  final int total;

  @override
  Widget build(BuildContext context) {
    if (total == 0) {
      return SizedBox(
        height: 260,
        child: Center(
          child: Text(
            'Run a scan to populate risk analytics.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 58,
              sectionsSpace: 3,
              startDegreeOffset: -90,
              sections: [
                for (final level in _levels)
                  PieChartSectionData(
                    value: (counts[level] ?? 0).toDouble(),
                    title: '${_percentage(level)}%',
                    radius: 72,
                    titleStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.background,
                          fontWeight: FontWeight.w900,
                        ),
                    color: RiskColors.accentFor(level),
                    showTitle: (counts[level] ?? 0) > 0,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            for (final level in _levels)
              _LegendItem(
                label: level.label, // ✅ NOW WORKS
                count: counts[level] ?? 0,
                color: RiskColors.accentFor(level),
              ),
          ],
        ),
      ],
    );
  }

  int _percentage(RiskLevel level) {
    if (total == 0) {
      return 0;
    }
    return (((counts[level] ?? 0) / total) * 100).round();
  }

  static const _levels = [
    RiskLevel.low,
    RiskLevel.medium,
    RiskLevel.high,
    RiskLevel.critical,
  ];
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.38),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label $count',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}