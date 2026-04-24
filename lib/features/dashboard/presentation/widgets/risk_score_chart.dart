import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../risk/domain/entities/risk_assessment.dart';

class RiskScoreChart extends StatelessWidget {
  const RiskScoreChart({required this.assessments, super.key});

  final List<RiskAssessment> assessments;

  @override
  Widget build(BuildContext context) {
    final values = assessments.take(6).toList().reversed.toList();

    return SizedBox(
      height: 220,
      child: values.isEmpty
          ? Center(
              child: Text(
                'Run a scan to build a risk trend.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          : LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.border.withOpacity(0.62),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 34,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: Theme.of(context).textTheme.labelSmall,
                        );
                      },
                    ),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    barWidth: 4,
                    color: AppColors.neonGreen,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.neonGreen.withOpacity(0.08),
                    ),
                    dotData: const FlDotData(show: true),
                    spots: [
                      for (var i = 0; i < values.length; i++)
                        FlSpot(i.toDouble(), values[i].score.toDouble()),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
