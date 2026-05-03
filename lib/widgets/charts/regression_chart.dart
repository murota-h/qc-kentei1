import 'dart:math';
import 'package:flutter/material.dart';

class RegressionChart extends StatelessWidget {
  const RegressionChart({super.key, required this.config});
  final Map<String, dynamic> config;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              config['title'] as String? ?? '重回帰分析（残差プロット付き）',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              '散布図（実測値 vs 予測値）と残差プロット',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 160,
                    child: CustomPaint(
                      painter: _FittedPainter(),
                      child: Container(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 160,
                    child: CustomPaint(
                      painter: _ResidualPainter(),
                      child: Container(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _LegendDot(color: Colors.blue[700]!, label: '実測値 vs 予測値'),
                const SizedBox(width: 16),
                _LegendDot(color: Colors.orange[700]!, label: '残差プロット'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _FittedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final dotPaint = Paint()..color = Colors.blue[700]!..style = PaintingStyle.fill;
    final linePaint = Paint()..color = Colors.red..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final axisPaint = Paint()..color = Colors.grey[400]!..strokeWidth = 1.0;

    canvas.drawLine(const Offset(24, 0), Offset(24, size.height - 20), axisPaint);
    canvas.drawLine(Offset(24, size.height - 20), Offset(size.width, size.height - 20), axisPaint);

    canvas.drawLine(Offset(24, size.height - 20), Offset(size.width - 4, 4), linePaint);

    for (int i = 0; i < 20; i++) {
      final t = (i + 1) / 21;
      final ideal = 24 + t * (size.width - 28);
      final idealY = size.height - 20 - t * (size.height - 24);
      final px = ideal + (rng.nextDouble() - 0.5) * 16;
      final py = idealY + (rng.nextDouble() - 0.5) * 20;
      canvas.drawCircle(Offset(px, py), 3.5, dotPaint);
    }

    _drawLabel(canvas, '予測値', Offset(size.width / 2, size.height - 14), size);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Size size) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: 9, color: Colors.grey[700])),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy));
  }

  @override
  bool shouldRepaint(_FittedPainter old) => false;
}

class _ResidualPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(99);
    final dotPaint = Paint()..color = Colors.orange[700]!..style = PaintingStyle.fill;
    final axisPaint = Paint()..color = Colors.grey[400]!..strokeWidth = 1.0;
    final zeroPaint = Paint()..color = Colors.red..strokeWidth = 1.0..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(24, 0), Offset(24, size.height - 20), axisPaint);
    canvas.drawLine(Offset(24, size.height - 20), Offset(size.width, size.height - 20), axisPaint);
    final midY = (size.height - 20) / 2;
    canvas.drawLine(Offset(24, midY), Offset(size.width, midY), zeroPaint);

    for (int i = 0; i < 20; i++) {
      final px = 28 + (i / 19) * (size.width - 32);
      final py = midY + (rng.nextDouble() - 0.5) * (size.height - 30);
      canvas.drawCircle(Offset(px, py), 3.5, dotPaint);
    }

    final tp = TextPainter(
      text: TextSpan(text: '予測値', style: TextStyle(fontSize: 9, color: Colors.grey[700])),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.width / 2 - tp.width / 2, size.height - 14));
  }

  @override
  bool shouldRepaint(_ResidualPainter old) => false;
}
