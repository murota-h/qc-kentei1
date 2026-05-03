import 'package:flutter/material.dart';
import '../models/content_block.dart';

class EssayPointBlockWidget extends StatefulWidget {
  const EssayPointBlockWidget({super.key, required this.block, required this.chapterColor});

  final EssayPointBlock block;
  final Color chapterColor;

  @override
  State<EssayPointBlockWidget> createState() => _EssayPointBlockWidgetState();
}

class _EssayPointBlockWidgetState extends State<EssayPointBlockWidget> {
  bool _showAnswer = false;
  final Set<int> _checked = {};

  @override
  Widget build(BuildContext context) {
    final b = widget.block;
    final allChecked = _checked.length == b.keyPoints.length;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1B0E),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note, color: Color(0xFFFFD54F), size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '論述テーマ',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFFFD54F),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Text(
                  '${b.sampleAnswer.length}字',
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              b.theme,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.5,
              ),
            ),
            const Divider(color: Colors.white24, height: 24),
            Row(
              children: [
                Text(
                  '論述キーポイント',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (allChecked)
                  const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
              ],
            ),
            const SizedBox(height: 8),
            ...b.keyPoints.asMap().entries.map((e) {
              final checked = _checked.contains(e.key);
              return InkWell(
                onTap: () => setState(() {
                  if (checked) {
                    _checked.remove(e.key);
                  } else {
                    _checked.add(e.key);
                  }
                }),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        checked ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 18,
                        color: checked ? Colors.greenAccent : Colors.white38,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.value,
                          style: TextStyle(
                            fontSize: 13,
                            color: checked ? const Color(0xFFB9F6CA) : Colors.white70,
                            decoration: checked ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.white38,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _showAnswer = !_showAnswer),
                icon: Icon(
                  _showAnswer ? Icons.visibility_off : Icons.visibility,
                  size: 16,
                  color: const Color(0xFFFFD54F),
                ),
                label: Text(
                  _showAnswer ? '解答例を閉じる' : '解答例を見る',
                  style: const TextStyle(color: Color(0xFFFFD54F), fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFF8F00)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            if (_showAnswer) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withAlpha(80)),
                ),
                child: Text(
                  b.sampleAnswer,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    height: 1.8,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
