import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'security_card.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.onTap,
    this.subtitle,
    this.isLoading = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SecurityCard(
      accentColor: accentColor,
      onTap: isLoading ? null : onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 112),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radius),
                    border: Border.all(color: accentColor.withOpacity(0.32)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: accentColor,
                            ),
                          )
                        : Icon(icon, color: accentColor, size: 20),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward, color: accentColor, size: 18),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
