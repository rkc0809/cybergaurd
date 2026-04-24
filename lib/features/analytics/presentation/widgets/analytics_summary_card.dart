import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/security_card.dart';

class AnalyticsSummaryCard extends StatelessWidget {
  const AnalyticsSummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SecurityCard(
      accentColor: accentColor,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              border: Border.all(color: accentColor.withOpacity(0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Icon(icon, color: accentColor),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
