import 'package:flutter/material.dart';
import '../../utils/statistics.dart';

class OcCurveAdvancedChart extends StatefulWidget {
  const OcCurveAdvancedChart({super.key, required this.config});
  final Map<String, dynamic> config;

  @override
  State<OcCurveAdvancedChart> createState() => _OcCurveAdvancedChartState();
}

class _OcCurveAdvancedChartState extends State<OcCurveAdvancedChart> {
  int _n = 50;
  int _c = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config['title'] as String? ?? 'OC曲線（検出力曲線）',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'n=$_n, c=$_c  — 二項分布による計算',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: CustomPaint(
                painter: _OcPainter(n: _n, c: _c),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 24, child: Text('n', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                Expanded(
                  child: Slider(
                    value: _n.toDouble(),
                    min: 10,
                    max: 200,
                    divisions: 19,
                    label: '$_n',
                    onChanged: (v) => setState(() => _n = v.round()),
                  ),
                ),
                SizedBox(width: 36, child: Text('$_n', style: const TextStyle(fontSize: 12))),
              ],
            ),
            Row(
              children: [
                const Text('c', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                ...[0, 1, 2, 3].map(
                  (v) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('$v', style: const TextStyle(fontSize: 11)),
                      selected: _c == v,
                      onSelected: (_) => setState(() => _c = v),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
              child: const Text(
                'n↑ → 曲線が急峻（理想OC曲線に近づく）\nc↑ → 曲線が右シフト（ゆるい検査基準）',
                style: TextStyle(fontSize: 11, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OcPainter extends CustomPainter {
  final int n, c;
  _OcPainter({required this.n, required this.c});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 32.0;
    const bottomPad = 24.0;
    final plotW = size.width - leftPad - 8;
    final plotH = size.height - bottomPad - 8;

    final axisPaint = Paint()..color = Colors.grey[400]!..strokeWidth = 1.0;
    final gridPaint = Paint()..color = Colors.grey[200]!..strokeWidth = 0.5;
    final linePaint = Paint()
      ..color = Colors.orange[700]!
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(leftPad, 8), Offset(leftPad, 8 + plotH), axisPaint);
    canvas.drawLine(Offset(leftPad, 8 + plotH), Offset(size.width - 8, 8 + plotH), axisPaint);

    // グリッド
    for (final pa in [0.25, 0.5, 0.75]) {
      final y = 8 + plotH * (1 - pa);
      canvas.drawLine(Offset(leftPad, y), Offset(size.width - 8, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(text: '${(pa * 100).toInt()}%', style: TextStyle(fontSize: 8, color: Colors.grey[500])),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, y - tp.height / 2));
    }

    // OC曲線
    final path = Path();
    for (int i = 0; i <= 100; i++) {
      final p = i / 100 * 0.20; // p: 0→0.20
      final pa = Statistics.binomialCdf(n, c, p);
      final px = leftPad + (p / 0.20) * plotW;
      final py = 8 + plotH * (1 - pa);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    canvas.drawPath(path, linePaint);

    // X軸ラベル
    for (final p in [0.05, 0.10, 0.15, 0.20]) {
      final px = leftPad + (p / 0.20) * plotW;
      final tp = TextPainter(
        text: TextSpan(text: '${(p * 100).toInt()}%', style: TextStyle(fontSize: 8, color: Colors.grey[600])),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(px - tp.width / 2, size.height - tp.height));
    }

    // 軸ラベル
    final paTp = TextPainter(
      text: TextSpan(text: 'Pa', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
      textDirection: TextDirection.ltr,
    )..layout();
    paTp.paint(canvas, const Offset(2, 2));

    final pTp = TextPainter(
      text: TextSpan(text: '不良率 p', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
      textDirection: TextDirection.ltr,
    )..layout();
    pTp.paint(canvas, Offset(size.width - pTp.width - 4, size.height - pTp.height));
  }

  @override
  bool shouldRepaint(_OcPainter old) => old.n != n || old.c != c;
}
