import 'package:flutter/material.dart';
import '../../models/content_block.dart';
import 'f_distribution_chart.dart';
import 'chi_square_chart.dart';
import 'anova_two_way_chart.dart';
import 'regression_chart.dart';
import 'pca_biplot_painter.dart';
import 'reliability_hazard_chart.dart';
import 'weibull_chart.dart';
import 'oc_curve_advanced_chart.dart';
import 'control_chart_advanced.dart';

class ChartDispatcher extends StatelessWidget {
  const ChartDispatcher({super.key, required this.block, required this.chapterColor});

  final ChartBlock block;
  final Color chapterColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: switch (block.chartType) {
        ChartType.fDistribution     => FDistributionChart(config: block.config),
        ChartType.chiSquare         => ChiSquareChart(config: block.config),
        ChartType.anovaTwoWay       => AnovaTwoWayChart(config: block.config),
        ChartType.regressionMultiple => RegressionChart(config: block.config),
        ChartType.pcaBiplot         => PcaBiplotWidget(config: block.config),
        ChartType.reliabilityHazard => ReliabilityHazardChart(config: block.config),
        ChartType.weibull           => WeibullChart(config: block.config),
        ChartType.ocCurveAdvanced   => OcCurveAdvancedChart(config: block.config),
        ChartType.controlChartAdvanced => ControlChartAdvanced(config: block.config),
      },
    );
  }
}
