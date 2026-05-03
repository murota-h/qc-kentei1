import 'package:flutter/material.dart';
import '../../utils/statistics.dart';

class ChiSquareChart extends StatefulWidget {
  const ChiSquareChart({super.key, required this.config});
  final Map<String, dynamic> config;

  @override
  State<ChiSquareChart> createState() => _ChiSquareChartState();
}

class _ChiSquareChartState extends State<ChiSquareChart> {
  double _df = 5;
  double _alpha = 0.05;

  double _chiCritical() {
    double lo = 0.01, hi = 80.0;
    for (int i = 0; i < 60; i++) {
      final mid = (lo + hi) / 2;
      final p = 1 - Statistics.chiSquareCdf(mid, _df);
      if (p > _alpha) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return (lo + hi) / 2;
  }

  @override
  Widget build(BuildContext context) {
    final crit = _chiCritical();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config['title'] as String? ?? 'カイ二乗分布',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'χ²(${_df.toInt()}) 上側${(_alpha * 100).toStringAsFixed(0)}%点 = ${crit.toStringAsFixed(3)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: CustomPaint(
                painter: _ChiSquarePainter(df: _df, alpha: _alpha, crit: crit),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(
                  width: 24,
                  child: Text('ν', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: Slider(
                    value: _df,
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: _df.toInt().toString(),
                    onChanged: (v) => setState(() => _df = v),
                  ),
                ),
                SizedBox(
                  width: 24,
                  child: Text(_df.toInt().toString(), style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Row(
              children: [
                const Text('α', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                ...[0.01, 0.05, 0.10].map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('${(a * 100).toInt()}%', style: const TextStyle(fontSize: 11)),
                      selected: _alpha == a,
                      onSelected: (_) => setState(() => _alpha = a),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChiSquarePainter extends CustomPainter {
  final double df, alpha, crit;
  _ChiSquarePainter({required this.df, required this.alpha, required this.crit});

  @override
  void paint(Canvas canvas, Size size) {
    final xMax = df + 4 * df.clamp(1, 6);
    final fillPaint = Paint()
      ..color = Colors.red.withAlpha(60)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = Colors.indigo[700]!
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final critPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    double yMax = 0.0;
    for (int i = 1; i <= 200; i++) {
      final x = xMax * i / 200;
      final v = Statistics.chiSquarePdf(x, df);
      if (v > yMax) yMax = v;
    }
    if (yMax <= 0) yMax = 1.0;

    double toSx(double x) => x / xMax * size.width;
    double toSy(double y) => size.height - (y / yMax) * size.height * 0.9;

    final fillPath = Path();
    bool started = false;
    for (int i = 0; i <= 200; i++) {
      final x = xMax * i / 200;
      if (x < crit) continue;
      final y = Statistics.chiSquarePdf(x, df);
      final px = toSx(x);
      final py = toSy(y);
      if (!started) {
        fillPath.moveTo(px, size.height);
        fillPath.lineTo(px, py);
        started = true;
      } else {
        fillPath.lineTo(px, py);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    final curvePath = Path();
    for (int i = 1; i <= 200; i++) {
      final x = xMax * i / 200;
      final y = Statistics.chiSquarePdf(x, df);
      final px = toSx(x);
      final py = toSy(y);
      if (i == 1) {
        curvePath.moveTo(px, py);
      } else {
        curvePath.lineTo(px, py);
      }
    }
    canvas.drawPath(curvePath, linePaint);

    final critX = toSx(crit);
    canvas.drawLine(Offset(critX, 0), Offset(critX, size.height), critPaint);

    final tp = TextPainter(
      text: TextSpan(
        text: crit.toStringAsFixed(2),
        style: const TextStyle(fontSize: 10, color: Colors.red),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(critX - tp.width / 2, size.height - tp.height));
  }

  @override
  bool shouldRepaint(_ChiSquarePainter old) => old.df != df || old.alpha != alpha;
}
