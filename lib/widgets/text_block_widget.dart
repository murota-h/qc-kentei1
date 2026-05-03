import 'package:flutter/material.dart';
import '../models/content_block.dart';

class TextBlockWidget extends StatelessWidget {
  const TextBlockWidget({super.key, required this.block, required this.chapterColor});

  final TextBlock block;
  final Color chapterColor;

  @override
  Widget build(BuildContext context) {
    return switch (block.style) {
      BlockStyle.heading2 => Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                block.text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: chapterColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(height: 2, width: 40, color: chapterColor),
            ],
          ),
        ),
      BlockStyle.heading3 => Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            block.text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      BlockStyle.body => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            block.text,
            style: const TextStyle(fontSize: 14, height: 1.8),
          ),
        ),
      BlockStyle.point => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(
                block.text,
                style: const TextStyle(fontSize: 14, height: 1.7),
              ),
            ),
          ],
        ),
      BlockStyle.caution => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(6),
            border: const Border(left: BorderSide(color: Color(0xFFBA7517), width: 4)),
          ),
          child: Text(block.text, style: const TextStyle(fontSize: 14, height: 1.7)),
        ),
      BlockStyle.note => Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            block.text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.7),
          ),
        ),
    };
  }
}
