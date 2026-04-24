import 'package:flutter/material.dart';

import '../models/risk_level.dart';
import 'app_colors.dart';

class RiskColors {
  const RiskColors._();

  static Color accentFor(RiskLevel level) {
    return switch (level) {
      RiskLevel.low => AppColors.neonGreen,
      RiskLevel.medium => AppColors.neonBlue,
      RiskLevel.high => AppColors.neonAmber,
      RiskLevel.critical => AppColors.neonRed,
    };
  }
}
