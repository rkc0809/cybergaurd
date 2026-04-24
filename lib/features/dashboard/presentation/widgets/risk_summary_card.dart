import 'package:flutter/material.dart';

import '../../../../core/models/risk_level.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/risk_indicator.dart';
import '../../../../shared/widgets/security_card.dart';
import '../../../risk/domain/entities/risk_assessment.dart';

class RiskSummaryCard extends StatelessWidget {
  const RiskSummaryCard({
    required this.latestAssessment,
    required this.averageScore,
    super.key,
  });

  final RiskAssessment? latestAssessment;
  final double averageScore;

  @override
  Widget build(BuildContext context) {
    final latest = latestAssessment;
    final score = latest?.score ?? 0;
    final level = latest?.level ?? RiskLevel.low;

    return SecurityCard(
      accentColor: latest == null ? AppColors.neonBlue : null,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Risk Summary',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              RiskIndicator(level: level, score: score),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            latest?.title ?? 'Placeholder assessment',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            latest == null
                ? 'No full scan has been run yet. Your device risk posture will appear here.'
                : 'Latest assessment from ${latest.category}. Average score ${averageScore.toStringAsFixed(1)}.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: AppColors.surfaceMuted,
              color: _barColor(level),
            ),
          ),
        ],
      ),
    );
  }

  Color _barColor(RiskLevel level) {
    return switch (level) {
      RiskLevel.low => AppColors.neonGreen,
      RiskLevel.medium => AppColors.neonBlue,
      RiskLevel.high => AppColors.neonAmber,
      RiskLevel.critical => AppColors.neonRed,
    };
  }
}
