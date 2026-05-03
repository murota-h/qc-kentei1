import 'package:flutter/material.dart';
import '../../utils/statistics.dart';

class FDistributionChart extends StatefulWidget {
  const FDistributionChart({super.key, required this.config});
  final Map<String, dynamic> config;

  @override
  State<FDistributionChart> createState() => _FDistributionChartState();
}

class _FDistributionChartState extends State<FDistributionChart> {
  double _phi1 = 5;
  double _phi2 = 10;
  double _alpha = 0.05;

  double _fCritical() {
    // ニュートン法で上側α点を求める
    double lo = 0.01, hi = 50.0;
    for (int i = 0; i < 60; i++) {
      final mid = (lo + hi) / 2;
      final p = 1 - Statistics.fCdf(mid, _phi1, _phi2);
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
    final fCrit = _fCritical();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config['title'] as String? ?? 'F分布',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'F(${_phi1.toInt()},${_phi2.toInt()}) 上側${(_alpha * 100).toStringAsFixed(0)}%点 = ${fCrit.toStringAsFixed(3)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: CustomPaint(
                painter: _FDistPainter(phi1: _phi1, phi2: _phi2, alpha: _alpha, fCrit: fCrit),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            _SliderRow(
              label: 'φ₁',
              value: _phi1,
              min: 1,
              max: 20,
              divisions: 19,
              onChanged: (v) => setState(() => _phi1 = v),
            ),
            _SliderRow(
              label: 'φ₂',
              value: _phi2,
              min: 1,
              max: 30,
              divisions: 29,
              onChanged: (v) => setState(() => _phi2 = v),
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

class _FDistPainter extends CustomPainter {
  final double phi1, phi2, alpha, fCrit;
  _FDistPainter({required this.phi1, required this.phi2, required this.alpha, required this.fCrit});

  @override
  void paint(Canvas canvas, Size size) {
    const xMax = 6.0;
    final fillPaint = Paint()
      ..color = Colors.red.withAlpha(60)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = Colors.blue[700]!
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final critPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // PDF最大値を求める（描画スケール用）
    double yMax = 0.0;
    for (int i = 1; i <= 200; i++) {
      final f = xMax * i / 200;
      final v = Statistics.fPdf(f, phi1, phi2);
      if (v > yMax) yMax = v;
    }
    if (yMax <= 0) yMax = 1.0;

    double toSx(double x) => x / xMax * size.width;
    double toSy(double y) => size.height - (y / yMax) * size.height * 0.9;

    // 塗りつぶし（上側α域）
    final fillPath = Path();
    bool fillStarted = false;
    for (int i = 0; i <= 200; i++) {
      final f = xMax * i / 200;
      if (f < fCrit) continue;
      final y = Statistics.fPdf(f, phi1, phi2);
      final px = toSx(f);
      final py = toSy(y);
      if (!fillStarted) {
        fillPath.moveTo(px, size.height);
        fillPath.lineTo(px, py);
        fillStarted = true;
      } else {
        fillPath.lineTo(px, py);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // PDF曲線
    final curvePath = Path();
    for (int i = 1; i <= 200; i++) {
      final f = xMax * i / 200;
      final y = Statistics.fPdf(f, phi1, phi2);
      final px = toSx(f);
      final py = toSy(y);
      if (i == 1) {
        curvePath.moveTo(px, py);
      } else {
        curvePath.lineTo(px, py);
      }
    }
    canvas.drawPath(curvePath, linePaint);

    // 臨界値の垂直線
    final critX = toSx(fCrit);
    canvas.drawLine(Offset(critX, 0), Offset(critX, size.height), critPaint);

    // X軸ラベル
    final tp = TextPainter(
      text: TextSpan(
        text: fCrit.toStringAsFixed(2),
        style: const TextStyle(fontSize: 10, color: Colors.red),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(critX - tp.width / 2, size.height - tp.height));
  }

  @override
  bool shouldRepaint(_FDistPainter old) =>
      old.phi1 != phi1 || old.phi2 != phi2 || old.alpha != alpha;
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });
  final String label;
  final double value, min, max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toInt().toString(),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 28,
          child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
