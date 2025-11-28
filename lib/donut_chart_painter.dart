import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _DonutChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Map<String, Color> colors;
  static const Color lightText = Color(0xFFEEEEEE);

  _DonutChartPainter(this.data, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: size.width / 2);
    const double strokeWidth = 25.0;

    double startAngle = -pi / 2;

    // Draw the segments
    for (var entry in data.entries) {
      final sweepAngle = entry.value * 2 * pi;
      final color = colors[entry.key] ?? Colors.grey;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Draw Arc
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

    // Draw the center hole
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'EXPOSURE',
        style: TextStyle(
          color: lightText.withOpacity(0.7),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
