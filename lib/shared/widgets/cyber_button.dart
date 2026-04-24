import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

enum CyberButtonVariant { primary, secondary, danger }

class CyberButton extends StatelessWidget {
  const CyberButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = CyberButtonVariant.primary,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final CyberButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final foreground = switch (variant) {
      CyberButtonVariant.primary => AppColors.background,
      CyberButtonVariant.secondary => AppColors.neonBlue,
      CyberButtonVariant.danger => AppColors.background,
    };
    final background = switch (variant) {
      CyberButtonVariant.primary => AppColors.neonGreen,
      CyberButtonVariant.secondary => AppColors.surface,
      CyberButtonVariant.danger => AppColors.neonRed,
    };
    final border = switch (variant) {
      CyberButtonVariant.primary => AppColors.neonGreen,
      CyberButtonVariant.secondary => AppColors.borderStrong,
      CyberButtonVariant.danger => AppColors.neonRed,
    };

    return SizedBox(
      height: AppSpacing.controlHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: onPressed == null
              ? null
              : [
                  BoxShadow(
                    color: border.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: FilledButton.icon(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: background,
            foregroundColor: foreground,
            disabledBackgroundColor: AppColors.surfaceMuted,
            disabledForegroundColor: AppColors.textMuted,
            side: BorderSide(color: border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
            ),
          ),
          icon: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                )
              : Icon(icon ?? Icons.bolt, size: 20),
          label: Text(label),
        ),
      ),
    );
  }
}
