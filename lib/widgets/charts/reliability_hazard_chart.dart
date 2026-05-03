import 'package:flutter/material.dart';
import '../../utils/statistics.dart';

class ReliabilityHazardChart extends StatefulWidget {
  const ReliabilityHazardChart({super.key, required this.config});
  final Map<String, dynamic> config;

  @override
  State<ReliabilityHazardChart> createState() => _ReliabilityHazardChartState();
}

class _ReliabilityHazardChartState extends State<ReliabilityHazardChart> {
  double _m = 1.5;
  final double _eta = 500.0;

  String get _phaseLabel {
    if (_m < 0.9) return '初期故障期（m < 1）';
    if (_m < 1.1) return '偶発故障期（m ≈ 1）';
    return '摩耗故障期（m > 1）';
  }

  Color get _phaseColor {
    if (_m < 0.9) return Colors.green[700]!;
    if (_m < 1.1) return Colors.blue[700]!;
    return Colors.red[700]!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config['title'] as String? ?? 'バスタブ曲線（ハザード関数の時間変化）',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _phaseLabel,
              style: TextStyle(fontSize: 12, color: _phaseColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 160,
              child: CustomPaint(
                painter: _HazardPainter(m: _m, eta: _eta, color: _phaseColor),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 28, child: Text('m', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                Expanded(
                  child: Slider(
                    value: _m,
                    min: 0.3,
                    max: 3.5,
                    divisions: 64,
                    label: _m.toStringAsFixed(2),
                    activeColor: _phaseColor,
                    onChanged: (v) => setState(() => _m = v),
                  ),
                ),
                SizedBox(width: 40, child: Text(_m.toStringAsFixed(2), style: const TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'm < 1: 初期故障（λ減少）　m ≈ 1: 偶発故障（λ一定 = 指数分布）　m > 1: 摩耗故障（λ増加）',
                style: TextStyle(fontSize: 11, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HazardPainter extends CustomPainter {
  final double m, eta;
  final Color color;

  _HazardPainter({required this.m, required this.eta, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const steps = 200;
    final tMax = eta * 2.5;

    final axisPaint = Paint()..color = Colors.grey[400]!..strokeWidth = 1.0;
    canvas.drawLine(const Offset(24, 0), Offset(24, size.height - 16), axisPaint);
    canvas.drawLine(Offset(24, size.height - 16), Offset(size.width, size.height - 16), axisPaint);

    double hMax = 0;
    for (int i = 1; i <= steps; i++) {
      final t = tMax * i / steps;
      final h = Statistics.weibullHazard(t, m, eta);
      if (h > hMax) hMax = h;
    }
    if (hMax <= 0) hMax = 1.0;
    hMax *= 1.1;

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 1; i <= steps; i++) {
      final t = tMax * i / steps;
      final h = Statistics.weibullHazard(t, m, eta);
      final px = 24 + (t / tMax) * (size.width - 28);
      final py = (size.height - 16) - (h / hMax) * (size.height - 20);
      if (i == 1) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    canvas.drawPath(path, linePaint);

    // ラベル
    _drawLabel(canvas, 'λ(t)', const Offset(2, 0));
    _drawLabel(canvas, '時間 t', Offset(size.width - 30, size.height - 14));
  }

  void _drawLabel(Canvas canvas, String text, Offset pos) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(_HazardPainter old) => old.m != m || old.eta != eta;
}
