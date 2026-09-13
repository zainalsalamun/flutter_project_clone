import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';

class CheckmarkPainter extends CustomPainter {
  CheckmarkPainter({required this.progress}) : super(repaint: progress);

  final Animation<double> progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = FoodPromoTheme.green
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8;
    final fill =
        Paint()
          ..color = FoodPromoTheme.green.withValues(alpha: 0.12)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2, fill);
    final path =
        Path()
          ..moveTo(size.width * 0.28, size.height * 0.53)
          ..lineTo(size.width * 0.44, size.height * 0.68)
          ..lineTo(size.width * 0.74, size.height * 0.36);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress.value),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CheckmarkPainter oldDelegate) => true;
}
