import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'analytic_provider.dart';

class CategoryExposureChart extends StatelessWidget {
  const CategoryExposureChart({super.key});

  static const Color lightText = Color(0xFFEEEEEE);
  static const Color brandBlue = Color(0xFF2E5CFF);
  static const Color accentGreen = Color(0xFF00CC99);
  static const Color cardSurface = Color(0xFF1E1E1E);



  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();
    final exposureMap = provider.exposureByCategories;
    final totalCapital = provider.totalInvestedCapital;

    if (exposureMap.isEmpty) {
      return Center(
        child: Text(
          'No positions to analyze.',
          style: TextStyle(color: lightText.withOpacity(0.6)),
        ),
      );
    }

    // Map categories to colors (can be extended)
    final categoryColors = {
      'Politics': brandBlue,
      'Crypto': const Color(0xFFFFA500),
      'Sports': const Color(0xFF6A5ACD),
      'Finance': accentGreen,
      'Tech': const Color(0xFF64B5F6),
    };

    // Calculate a list of chart sections
    final sections = exposureMap.entries.map((entry) {
      final category = entry.key;
      final percentage = entry.value;
      final color = categoryColors[category] ?? Colors.grey;

      // The label for the section list
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: const TextStyle(
                color: lightText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '${(percentage * 100).toStringAsFixed(1)}%',
              style: TextStyle(color: lightText.withOpacity(0.8)),
            ),
          ],
        ),
      );
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Capital Exposure Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: lightText,
              ),
            ),
            const SizedBox(height: 16),
            // Mock Donut Chart
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: _DonutChartPainter(exposureMap, categoryColors),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: cardSurface),
            const SizedBox(height: 8),
            ...sections,
            const SizedBox(height: 8),
            Text(
              'Total Capital: \$${totalCapital.toStringAsFixed(2)}',
              style: TextStyle(color: lightText.withOpacity(0.6), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
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


      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }

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
