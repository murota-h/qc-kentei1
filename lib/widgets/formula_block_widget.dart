import 'package:flutter/material.dart';
import '../models/content_block.dart';

class FormulaBlockWidget extends StatelessWidget {
  const FormulaBlockWidget({super.key, required this.block, required this.chapterColor});

  final FormulaBlock block;
  final Color chapterColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: chapterColor, width: 4)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: chapterColor.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                block.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: chapterColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                block.formula,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.9,
                ),
              ),
            ),
            if (block.explanation != null) ...[
              const SizedBox(height: 8),
              Text(
                block.explanation!,
                style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
