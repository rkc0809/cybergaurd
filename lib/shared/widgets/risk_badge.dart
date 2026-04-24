import 'package:flutter/material.dart';

import '../../core/models/risk_level.dart';
import 'risk_indicator.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({
    required this.level,
    this.score,
    super.key,
  });

  final RiskLevel level;
  final int? score;

  @override
  Widget build(BuildContext context) {
    return RiskIndicator(
      level: level,
      score: score ?? level.minScore,
      compact: score == null,
    );
  }
}
