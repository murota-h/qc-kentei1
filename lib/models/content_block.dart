sealed class ContentBlock {
  const ContentBlock();
}

class TextBlock extends ContentBlock {
  final String text;
  final BlockStyle style;
  const TextBlock({required this.text, required this.style});
}

class FormulaBlock extends ContentBlock {
  final String label;
  final String formula;
  final String? explanation;
  const FormulaBlock({required this.label, required this.formula, this.explanation});
}

class TableBlock extends ContentBlock {
  final String? title;
  final List<String> headers;
  final List<List<String>> rows;
  const TableBlock({this.title, required this.headers, required this.rows});
}

class ExampleBlock extends ContentBlock {
  final String id;
  final String question;
  final String? hint;
  final String answer;
  final String explanation;
  const ExampleBlock({
    required this.id,
    required this.question,
    this.hint,
    required this.answer,
    required this.explanation,
  });
}

class PointBlock extends ContentBlock {
  final String title;
  final List<String> points;
  const PointBlock({required this.title, required this.points});
}

class CautionBlock extends ContentBlock {
  final String text;
  const CautionBlock({required this.text});
}

class ChartBlock extends ContentBlock {
  final ChartType chartType;
  final Map<String, dynamic> config;
  const ChartBlock({required this.chartType, this.config = const {}});
}

class EssayPointBlock extends ContentBlock {
  final String theme;
  final List<String> keyPoints;
  final String sampleAnswer;
  const EssayPointBlock({
    required this.theme,
    required this.keyPoints,
    required this.sampleAnswer,
  });
}

enum BlockStyle { heading2, heading3, body, point, caution, note }

enum ChartType {
  fDistribution,
  chiSquare,
  anovaTwoWay,
  regressionMultiple,
  pcaBiplot,
  reliabilityHazard,
  weibull,
  ocCurveAdvanced,
  controlChartAdvanced,
}
