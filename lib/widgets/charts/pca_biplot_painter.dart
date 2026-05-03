import 'dart:math';
import 'package:flutter/material.dart';

class PcaBiplotWidget extends StatelessWidget {
  const PcaBiplotWidget({super.key, required this.config});
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
              config['title'] as String? ?? '主成分分析バイプロット',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'スコア（サンプルの位置）＋ローディング（変数の寄与方向）',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: CustomPaint(
                painter: _BiplotPainter(),
                child: Container(),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _LegendItem(color: Colors.blue[600]!, shape: 'circle', label: 'スコア（サンプル）'),
                const SizedBox(width: 16),
                _LegendItem(color: Colors.red[700]!, shape: 'arrow', label: 'ローディング（変数）'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.shape, required this.label});
  final Color color;
  final String shape;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: shape == 'circle' ? BoxShape.circle : BoxShape.rectangle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}

class _BiplotPainter extends CustomPainter {
  // 固定のサンプルスコア（PC1, PC2）
  static const _scores = [
    [-1.8, 0.5], [-1.2, -0.8], [-0.6, 1.2], [0.2, 0.9],
    [0.8, -0.3], [1.5, 0.6], [1.2, -1.1], [-0.4, -1.5],
    [0.5, 1.4], [-0.9, 0.2], [1.8, -0.5], [-1.5, -0.4],
  ];
  // 変数のローディング（PC1, PC2）
  static const _loadings = [
    [0.72, 0.45],  // x1
    [-0.68, 0.52], // x2
    [0.55, -0.70], // x3
    [0.80, -0.20], // x4
  ];
  static const _varNames = ['x₁', 'x₂', 'x₃', 'x₄'];

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = min(cx, cy) * 0.8;

    final axisPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), axisPaint);
    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), axisPaint);

    // スコアプロット
    final dotPaint = Paint()..color = Colors.blue[600]!..style = PaintingStyle.fill;
    for (final s in _scores) {
      final px = cx + s[0] * scale * 0.45;
      final py = cy - s[1] * scale * 0.45;
      canvas.drawCircle(Offset(px, py), 5, dotPaint);
    }

    // ローディングベクトル
    final arrowPaint = Paint()
      ..color = Colors.red[700]!
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < _loadings.length; i++) {
      final lx = _loadings[i][0] * scale * 0.85;
      final ly = _loadings[i][1] * scale * 0.85;
      canvas.drawLine(Offset(cx, cy), Offset(cx + lx, cy - ly), arrowPaint);

      // 矢先
      final angle = atan2(-ly, lx);
      const arrowLen = 8.0;
      const arrowAngle = 0.4;
      canvas.drawLine(
        Offset(cx + lx, cy - ly),
        Offset(cx + lx - arrowLen * cos(angle - arrowAngle),
               cy - ly + arrowLen * sin(angle - arrowAngle)),
        arrowPaint,
      );
      canvas.drawLine(
        Offset(cx + lx, cy - ly),
        Offset(cx + lx - arrowLen * cos(angle + arrowAngle),
               cy - ly + arrowLen * sin(angle + arrowAngle)),
        arrowPaint,
      );

      // 変数名ラベル
      final tp = TextPainter(
        text: TextSpan(
          text: _varNames[i],
          style: TextStyle(fontSize: 11, color: Colors.red[700], fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(cx + lx + 4, cy - ly - tp.height / 2));
    }

    // 軸ラベル
    _drawAxisLabel(canvas, 'PC1', Offset(size.width - 28, cy + 4));
    _drawAxisLabel(canvas, 'PC2', Offset(cx + 4, 4));
  }

  void _drawAxisLabel(Canvas canvas, String text, Offset pos) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(_BiplotPainter old) => false;
}
