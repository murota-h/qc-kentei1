import 'package:flutter/material.dart';

class AnovaTwoWayChart extends StatefulWidget {
  const AnovaTwoWayChart({super.key, required this.config});
  final Map<String, dynamic> config;

  @override
  State<AnovaTwoWayChart> createState() => _AnovaTwoWayChartState();
}

class _AnovaTwoWayChartState extends State<AnovaTwoWayChart> {
  // A3水準 × B2水準の平均値（スライダーで変更可）
  // [A1B1, A1B2], [A2B1, A2B2], [A3B1, A3B2]
  final List<List<double>> _means = [
    [10.0, 15.0],
    [20.0, 25.0],
    [15.0, 20.0],
  ];
  bool _hasInteraction = false;

  void _toggleInteraction() {
    setState(() {
      if (_hasInteraction) {
        // 交互作用なし（平行線）に戻す
        _means[0][0] = 10.0;
        _means[0][1] = 15.0;
        _means[1][0] = 20.0;
        _means[1][1] = 25.0;
        _means[2][0] = 15.0;
        _means[2][1] = 20.0;
        _hasInteraction = false;
      } else {
        // 交互作用あり（交差）
        _means[0][0] = 10.0;
        _means[0][1] = 25.0;
        _means[1][0] = 20.0;
        _means[1][1] = 18.0;
        _means[2][0] = 15.0;
        _means[2][1] = 12.0;
        _hasInteraction = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final aLevels = (widget.config['factor_a_levels'] as List?)?.cast<String>() ?? ['A₁', 'A₂', 'A₃'];
    final bLevels = (widget.config['factor_b_levels'] as List?)?.cast<String>() ?? ['B₁', 'B₂'];
    final colors = [Colors.blue[700]!, Colors.orange[700]!];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.config['title'] as String? ?? '二元配置実験の交互作用プロット',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _hasInteraction ? '交互作用あり（線が交差）' : '交互作用なし（線が平行）',
              style: TextStyle(
                fontSize: 12,
                color: _hasInteraction ? Colors.red[700] : Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: CustomPaint(
                painter: _InteractionPlotPainter(
                  means: _means,
                  aLevels: aLevels,
                  bLevels: bLevels,
                  colors: colors,
                ),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            // 凡例
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: bLevels.asMap().entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Container(width: 20, height: 3, color: colors[e.key]),
                      const SizedBox(width: 4),
                      Text(e.value, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _toggleInteraction,
                icon: Icon(_hasInteraction ? Icons.swap_horiz : Icons.trending_up, size: 16),
                label: Text(_hasInteraction ? '交互作用なしに切替' : '交互作用ありに切替'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InteractionPlotPainter extends CustomPainter {
  final List<List<double>> means;
  final List<String> aLevels;
  final List<String> bLevels;
  final List<Color> colors;

  _InteractionPlotPainter({
    required this.means,
    required this.aLevels,
    required this.bLevels,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPad = 32.0;
    const bottomPad = 24.0;
    final plotW = size.width - leftPad - 8;
    final plotH = size.height - bottomPad - 8;

    double yMin = double.infinity;
    double yMax = double.negativeInfinity;
    for (final row in means) {
      for (final v in row) {
        if (v < yMin) yMin = v;
        if (v > yMax) yMax = v;
      }
    }
    final yRange = (yMax - yMin).clamp(1.0, double.infinity);
    yMin -= yRange * 0.1;
    yMax += yRange * 0.1;

    double toX(int i) => leftPad + (i / (aLevels.length - 1)) * plotW;
    double toY(double v) => 8 + plotH - (v - yMin) / (yMax - yMin) * plotH;

    // 軸
    final axisPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1.0;
    canvas.drawLine(const Offset(leftPad, 8.0), Offset(leftPad, 8.0 + plotH), axisPaint);
    canvas.drawLine(Offset(leftPad, 8.0 + plotH), Offset(size.width - 8, 8.0 + plotH), axisPaint);

    // 各Bレベルの折れ線
    for (int b = 0; b < bLevels.length; b++) {
      final linePaint = Paint()
        ..color = colors[b]
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      final dotPaint = Paint()
        ..color = colors[b]
        ..style = PaintingStyle.fill;

      final path = Path();
      for (int a = 0; a < aLevels.length; a++) {
        final px = toX(a);
        final py = toY(means[a][b]);
        if (a == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
        canvas.drawCircle(Offset(px, py), 5, dotPaint);
      }
      canvas.drawPath(path, linePaint);
    }

    // X軸ラベル
    for (int a = 0; a < aLevels.length; a++) {
      final tp = TextPainter(
        text: TextSpan(
          text: aLevels[a],
          style: TextStyle(fontSize: 10, color: Colors.grey[700]),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(toX(a) - tp.width / 2, size.height - tp.height));
    }
  }

  @override
  bool shouldRepaint(_InteractionPlotPainter old) => old.means != means;
}
