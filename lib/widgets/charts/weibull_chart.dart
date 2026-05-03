import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/statistics.dart';

class WeibullChart extends StatefulWidget {
  const WeibullChart({super.key, required this.config});
  final Map<String, dynamic> config;

  @override
  State<WeibullChart> createState() => _WeibullChartState();
}

class _WeibullChartState extends State<WeibullChart> {
  double _m = 2.0;
  double _eta = 500.0;

  String get _phaseLabel {
    if (_m < 0.9) return '初期故障期';
    if (_m < 1.1) return '偶発故障期（指数分布）';
    return '摩耗故障期';
  }

  Color get _lineColor {
    if (_m < 0.9) return Colors.green[700]!;
    if (_m < 1.1) return Colors.blue[700]!;
    return Colors.red[700]!;
  }

  @override
  Widget build(BuildContext context) {
    final mttf = Statistics.weibullMTTF(_m, _eta);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config['title'] as String? ?? 'ワイブルプロット（確率紙）',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'MTTF = ${mttf.toStringAsFixed(1)}時間  |  $_phaseLabel',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: CustomPaint(
                painter: _WeibullProbPainter(m: _m, eta: _eta, color: _lineColor),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            _SliderRow(
              label: 'm',
              value: _m,
              min: 0.5,
              max: 4.0,
              divisions: 35,
              display: _m.toStringAsFixed(2),
              color: _lineColor,
              onChanged: (v) => setState(() => _m = v),
            ),
            _SliderRow(
              label: 'η',
              value: _eta,
              min: 100,
              max: 1000,
              divisions: 90,
              display: _eta.toStringAsFixed(0),
              color: Colors.grey[600]!,
              onChanged: (v) => setState(() => _eta = v),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.color,
    required this.onChanged,
  });
  final String label, display;
  final double value, min, max;
  final int divisions;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: color,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 48, child: Text(display, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}

class _WeibullProbPainter extends CustomPainter {
  final double m, eta;
  final Color color;

  _WeibullProbPainter({required this.m, required this.eta, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 32.0;
    const bottomPad = 20.0;
    final plotW = size.width - leftPad - 8;
    final plotH = size.height - bottomPad - 8;

    final axisPaint = Paint()..color = Colors.grey[400]!..strokeWidth = 0.8;
    final gridPaint = Paint()..color = Colors.grey[200]!..strokeWidth = 0.5;
    final linePaint = Paint()..color = color..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final dotPaint = Paint()..color = Colors.red[700]!..style = PaintingStyle.fill;

    // 軸
    canvas.drawLine(const Offset(leftPad, 8), Offset(leftPad, 8 + plotH), axisPaint);
    canvas.drawLine(Offset(leftPad, 8 + plotH), Offset(size.width - 8, 8 + plotH), axisPaint);

    // グリッド（F = 10%, 50%, 90%）
    for (final f in [0.1, 0.5, 0.9]) {
      final y = 8 + plotH * (1 - f);
      canvas.drawLine(Offset(leftPad, y), Offset(size.width - 8, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(text: '${(f * 100).toInt()}%', style: TextStyle(fontSize: 8, color: Colors.grey[500])),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(2, y - tp.height / 2));
    }

    // ワイブル直線 F(t) = 1 - exp(-(t/η)^m)
    final path = Path();
    bool first = true;
    for (int i = 1; i <= 200; i++) {
      final t = eta * 0.05 + eta * 2.5 * i / 200;
      final f = 1 - Statistics.weibullReliability(t, m, eta);
      if (f <= 0.001 || f >= 0.999) continue;
      // X: ln(t) を線形スケールにマッピング
      final tMin = eta * 0.05;
      final tMax = eta * 2.55;
      final px = leftPad + (log(t) - log(tMin)) / (log(tMax) - log(tMin)) * plotW;
      final py = 8 + plotH * (1 - f);
      if (first) {
        path.moveTo(px, py);
        first = false;
      } else {
        path.lineTo(px, py);
      }
    }
    canvas.drawPath(path, linePaint);

    // η の点（F=63.2%）にマーカー
    final etaF = 1 - Statistics.weibullReliability(eta, m, eta);
    final tMin = eta * 0.05;
    final tMax = eta * 2.55;
    final etaPx = leftPad + (log(eta) - log(tMin)) / (log(tMax) - log(tMin)) * plotW;
    final etaPy = 8 + plotH * (1 - etaF);
    canvas.drawCircle(Offset(etaPx, etaPy), 5, dotPaint);

    // η ラベル
    final tp = TextPainter(
      text: const TextSpan(text: 'η', style: TextStyle(fontSize: 10, color: Colors.red)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(etaPx - tp.width / 2, etaPy + 6));

    // 軸ラベル
    final xTp = TextPainter(
      text: TextSpan(text: 'ln(t)', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
      textDirection: TextDirection.ltr,
    )..layout();
    xTp.paint(canvas, Offset(size.width - xTp.width - 4, size.height - xTp.height));
  }

  @override
  bool shouldRepaint(_WeibullProbPainter old) => old.m != m || old.eta != eta;
}
