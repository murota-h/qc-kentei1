import 'dart:math';
import 'package:flutter/material.dart';

class ControlChartAdvanced extends StatefulWidget {
  const ControlChartAdvanced({super.key, required this.config});
  final Map<String, dynamic> config;

  @override
  State<ControlChartAdvanced> createState() => _ControlChartAdvancedState();
}

class _ControlChartAdvancedState extends State<ControlChartAdvanced> {
  double _shiftSize = 1.5;
  final int _shiftPoint = 15;

  List<double> _generateData(int n, double shiftAt, double shiftSize) {
    final rng = Random(42);
    return List.generate(n, (i) {
      final noise = _boxMuller(rng);
      return i >= shiftAt ? noise + shiftSize : noise;
    });
  }

  double _boxMuller(Random rng) {
    final u1 = rng.nextDouble();
    final u2 = rng.nextDouble();
    return sqrt(-2 * log(u1 + 1e-10)) * cos(2 * pi * u2);
  }

  @override
  Widget build(BuildContext context) {
    const n = 30;
    final data = _generateData(n, _shiftPoint.toDouble(), _shiftSize);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config['title'] as String? ?? '管理図比較（X̄ vs CUSUM）',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'シフト点: $_shiftPointサンプル目  シフト量: ${_shiftSize.toStringAsFixed(1)}σ',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            const Text('通常の管理図 (X̄)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            SizedBox(
              height: 120,
              child: CustomPaint(
                painter: _XbarPainter(data: data),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            const Text('CUSUM 管理図', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            SizedBox(
              height: 120,
              child: CustomPaint(
                painter: _CusumPainter(data: data),
                child: Container(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 72, child: Text('シフト量', style: TextStyle(fontSize: 12))),
                Expanded(
                  child: Slider(
                    value: _shiftSize,
                    min: 0.5,
                    max: 3.0,
                    divisions: 25,
                    label: '${_shiftSize.toStringAsFixed(1)}σ',
                    onChanged: (v) => setState(() => _shiftSize = v),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text('${_shiftSize.toStringAsFixed(1)}σ', style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
              child: const Text(
                'CUSUMは小さなシフト（≤1.5σ）を通常管理図より早く検出できる',
                style: TextStyle(fontSize: 11, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _XbarPainter extends CustomPainter {
  final List<double> data;
  _XbarPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 24.0;
    const bottomPad = 16.0;
    final plotW = size.width - leftPad - 8;
    final plotH = size.height - bottomPad - 4;

    final axisPaint = Paint()..color = Colors.grey[400]!..strokeWidth = 0.8;
    final clPaint = Paint()..color = Colors.green..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final uclPaint = Paint()..color = Colors.red..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final dotPaint = Paint()..color = Colors.blue[700]!..style = PaintingStyle.fill;
    final alarmPaint = Paint()..color = Colors.red..style = PaintingStyle.fill;

    canvas.drawLine(const Offset(leftPad, 4), Offset(leftPad, 4 + plotH), axisPaint);
    canvas.drawLine(Offset(leftPad, 4 + plotH), Offset(size.width - 8, 4 + plotH), axisPaint);

    const yMin = -4.0, yMax = 4.0, yRange = 8.0;
    double toY(double v) => 4 + plotH - ((v - yMin) / yRange) * plotH;
    double toX(int i) => leftPad + (i / (data.length - 1)) * plotW;

    canvas.drawLine(Offset(leftPad, toY(3)), Offset(size.width - 8, toY(3)), uclPaint);
    canvas.drawLine(Offset(leftPad, toY(-3)), Offset(size.width - 8, toY(-3)), uclPaint);
    canvas.drawLine(Offset(leftPad, toY(0)), Offset(size.width - 8, toY(0)), clPaint);

    final linePaint = Paint()..color = Colors.blue[700]!..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final px = toX(i);
      final py = toY(data[i].clamp(yMin, yMax));
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
      final alarm = data[i].abs() > 3;
      canvas.drawCircle(Offset(px, py), 3.5, alarm ? alarmPaint : dotPaint);
    }
    canvas.drawPath(path, linePaint);

    _drawLabel(canvas, 'UCL', Offset(size.width - 28, toY(3) - 10));
    _drawLabel(canvas, 'LCL', Offset(size.width - 28, toY(-3) + 2));
  }

  void _drawLabel(Canvas canvas, String text, Offset pos) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(fontSize: 9, color: Colors.red)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(_XbarPainter old) => old.data != data;
}

class _CusumPainter extends CustomPainter {
  final List<double> data;
  _CusumPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 24.0;
    const bottomPad = 16.0;
    final plotW = size.width - leftPad - 8;
    final plotH = size.height - bottomPad - 4;
    const k = 0.5;
    const h = 4.0;

    final axisPaint = Paint()..color = Colors.grey[400]!..strokeWidth = 0.8;
    final hPaint = Paint()..color = Colors.red..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final cPosP = Paint()..color = Colors.orange[700]!..strokeWidth = 2.0..style = PaintingStyle.stroke;
    final cNegP = Paint()..color = Colors.purple[700]!..strokeWidth = 2.0..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(leftPad, 4), Offset(leftPad, 4 + plotH), axisPaint);
    canvas.drawLine(Offset(leftPad, 4 + plotH), Offset(size.width - 8, 4 + plotH), axisPaint);

    double cPos = 0, cNeg = 0;
    final cPosList = <double>[], cNegList = <double>[];
    for (final x in data) {
      cPos = max(0, cPos + x - k);
      cNeg = max(0, cNeg - x - k);
      cPosList.add(cPos);
      cNegList.add(cNeg);
    }

    const yMax = 6.0;
    double toY(double v) => 4 + plotH - (v.clamp(0, yMax) / yMax) * plotH;
    double toX(int i) => leftPad + (i / (data.length - 1)) * plotW;

    canvas.drawLine(Offset(leftPad, toY(h)), Offset(size.width - 8, toY(h)), hPaint);

    Path buildPath(List<double> vals) {
      final p = Path();
      for (int i = 0; i < vals.length; i++) {
        if (i == 0) {
          p.moveTo(toX(i), toY(vals[i]));
        } else {
          p.lineTo(toX(i), toY(vals[i]));
        }
      }
      return p;
    }

    canvas.drawPath(buildPath(cPosList), cPosP);
    canvas.drawPath(buildPath(cNegList), cNegP);

    _drawLabel(canvas, 'h=${h.toInt()}', Offset(size.width - 32, toY(h) - 10));
    _drawLabel(canvas, 'C⁺', Offset(leftPad + 4, toY(cPosList.last) - 10), Colors.orange[700]!);
    _drawLabel(canvas, 'C⁻', Offset(leftPad + 4, toY(cNegList.last) + 2), Colors.purple[700]!);
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, [Color color = Colors.red]) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: 9, color: color)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(_CusumPainter old) => old.data != data;
}
