import 'package:flutter/material.dart';
import '../models/content_block.dart';
import 'text_block_widget.dart';
import 'formula_block_widget.dart';
import 'table_block_widget.dart';
import 'example_block_widget.dart';
import 'point_block_widget.dart';
import 'essay_point_block_widget.dart';
import 'charts/chart_dispatcher.dart';

class ContentBlockWidget extends StatelessWidget {
  const ContentBlockWidget({
    super.key,
    required this.block,
    required this.chapterColor,
  });

  final ContentBlock block;
  final Color chapterColor;

  @override
  Widget build(BuildContext context) {
    return switch (block) {
      TextBlock b => TextBlockWidget(block: b, chapterColor: chapterColor),
      FormulaBlock b => FormulaBlockWidget(block: b, chapterColor: chapterColor),
      TableBlock b => TableBlockWidget(block: b),
      ExampleBlock b => ExampleBlockWidget(block: b, chapterColor: chapterColor),
      PointBlock b => PointBlockWidget(block: b, chapterColor: chapterColor),
      CautionBlock b => CautionBlockWidget(block: b),
      ChartBlock b => ChartDispatcher(block: b, chapterColor: chapterColor),
      EssayPointBlock b => EssayPointBlockWidget(block: b, chapterColor: chapterColor),
    };
  }
}
