import 'package:flutter/material.dart';

import '../../core/models/risk_level.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/risk_colors.dart';

class RiskIndicator extends StatelessWidget {
  const RiskIndicator({
    required this.level,
    required this.score,
    this.compact = false,
    super.key,
  });

  final RiskLevel level;
  final int score;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final accent = RiskColors.accentFor(level);
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        border: Border.all(color: accent.withOpacity(0.42)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
          vertical: compact ? 6 : AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 7 : 9,
              height: compact ? 7 : 9,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.45),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              compact ? '$score' : '${level.label} $score',
              style: (compact ? textTheme.labelMedium : textTheme.labelLarge)?.copyWith(
                color: accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
