import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() => dark();

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
    );
    final textTheme = _textTheme(base.textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonGreen,
        secondary: AppColors.neonBlue,
        tertiary: AppColors.neonRed,
        surface: AppColors.surface,
        error: AppColors.neonRed,
        onPrimary: AppColors.background,
        onSecondary: AppColors.background,
        onSurface: AppColors.textPrimary,
        onError: AppColors.background,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: const IconThemeData(color: AppColors.textSecondary),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radius)),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceMuted,
        disabledColor: AppColors.surface,
        selectedColor: AppColors.neonBlue.withOpacity(0.18),
        secondarySelectedColor: AppColors.neonGreen.withOpacity(0.18),
        labelStyle: textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
        secondaryLabelStyle: textTheme.labelMedium,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.controlHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          textStyle: textTheme.labelLarge,
          backgroundColor: AppColors.neonGreen,
          foregroundColor: AppColors.background,
          disabledBackgroundColor: AppColors.surfaceMuted,
          disabledForegroundColor: AppColors.textMuted,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSpacing.controlHeight),
          side: const BorderSide(color: AppColors.borderStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
          textStyle: textTheme.labelLarge,
          foregroundColor: AppColors.neonBlue,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        prefixIconColor: AppColors.neonBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          borderSide: const BorderSide(color: AppColors.neonGreen, width: 1.4),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: AppColors.neonBlue,
        textColor: AppColors.textPrimary,
        subtitleTextStyle: textTheme.bodySmall,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.neonGreen.withOpacity(0.16),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall?.copyWith(
            color: states.contains(WidgetState.selected)
                ? AppColors.neonGreen
                : AppColors.textMuted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.neonGreen
                : AppColors.textMuted,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      textTheme: textTheme,
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    return base.copyWith(
      displaySmall: base.displaySmall?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 34,
        height: 1.08,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 16,
        height: 1.25,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 14,
        height: 1.25,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        fontSize: 14,
        height: 1.45,
        letterSpacing: 0,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: AppColors.textMuted,
        fontSize: 12,
        height: 1.35,
        letterSpacing: 0,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontSize: 12,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 11,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      ),
    );
  }
}
