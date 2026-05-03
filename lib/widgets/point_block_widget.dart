import 'package:flutter/material.dart';
import '../models/content_block.dart';

class PointBlockWidget extends StatelessWidget {
  const PointBlockWidget({super.key, required this.block, required this.chapterColor});

  final PointBlock block;
  final Color chapterColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: chapterColor.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: chapterColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: chapterColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  block.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: chapterColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...block.points.map(
            (p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: chapterColor, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(p, style: const TextStyle(fontSize: 13, height: 1.6)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CautionBlockWidget extends StatelessWidget {
  const CautionBlockWidget({super.key, required this.block});

  final CautionBlock block;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF8E1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border(left: BorderSide(color: Color(0xFFBA7517), width: 4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber, color: Color(0xFFBA7517), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(block.text, style: const TextStyle(fontSize: 13, height: 1.7)),
          ),
        ],
      ),
    );
  }
}
