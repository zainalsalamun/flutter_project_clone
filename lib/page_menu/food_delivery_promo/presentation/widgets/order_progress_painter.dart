import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';

class OrderProgressPainter extends CustomPainter {
  OrderProgressPainter({required this.progress, required this.steps});

  final double progress;
  final List<String> steps;

  @override
  void paint(Canvas canvas, Size size) {
    final left = size.width * 0.18;
    final top = 34.0;
    final bottom = size.height - 52;
    final gap = (bottom - top) / (steps.length - 1);
    final linePaint =
        Paint()
          ..color = const Color(0xFFFFD9B7)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;
    final activePaint =
        Paint()
          ..color = FoodPromoTheme.orange
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(left, top), Offset(left, bottom), linePaint);
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + (bottom - top) * progress),
      activePaint,
    );

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < steps.length; i++) {
      final y = top + gap * i;
      final stepProgress = (progress * (steps.length - 1));
      final active = stepProgress >= i;
      final pulse =
          active && (stepProgress - i).abs() < 0.7
              ? math.sin(progress * math.pi * 16).abs()
              : 0.0;
      canvas.drawCircle(
        Offset(left, y),
        17 + pulse * 4,
        Paint()..color = active ? FoodPromoTheme.orange : Colors.white,
      );
      canvas.drawCircle(
        Offset(left, y),
        17,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = active ? FoodPromoTheme.orange : const Color(0xFFFFD9B7),
      );
      textPainter.text = TextSpan(
        text: steps[i],
        style: TextStyle(
          color: active ? FoodPromoTheme.ink : FoodPromoTheme.muted,
          fontSize: 17,
          fontWeight: FontWeight.w900,
        ),
      );
      textPainter.layout(maxWidth: size.width - left - 56);
      textPainter.paint(canvas, Offset(left + 42, y - 12));
    }

    final driverY = top + (bottom - top) * progress;
    final driverRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(left - 4, driverY), width: 44, height: 44),
      const Radius.circular(16),
    );
    canvas.drawRRect(driverRect, Paint()..color = FoodPromoTheme.ink);
    const icon = Icons.delivery_dining_rounded;
    final builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(fontFamily: icon.fontFamily, fontSize: 24),
    )..addText(String.fromCharCode(icon.codePoint));
    final paragraph =
        builder.build()..layout(const ui.ParagraphConstraints(width: 30));
    canvas.drawParagraph(paragraph, Offset(left - 17, driverY - 15));
  }

  @override
  bool shouldRepaint(covariant OrderProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
