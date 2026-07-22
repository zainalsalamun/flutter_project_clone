import 'dart:math' as math;
import 'package:flutter/material.dart';

class HologramOrbitPainter extends CustomPainter {
  final double angle;
  final double radius;

  HologramOrbitPainter({required this.angle, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw outer orbital circle 1 (tilted)
    final orbit1Paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.0), Colors.purpleAccent.withOpacity(0.2), Colors.purpleAccent.withOpacity(0.05)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle * 0.4);
    canvas.scale(1.0, 0.45);
    canvas.drawCircle(Offset.zero, radius, orbit1Paint);
    
    // Draw orbital glowing dot
    final dotPaint = Paint()
      ..color = Colors.cyanAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(radius * math.cos(angle), radius * math.sin(angle)), 3.5, dotPaint);
    canvas.restore();

    // Draw outer orbital circle 2 (opposite tilt)
    final orbit2Paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.0), Colors.pinkAccent.withOpacity(0.2), Colors.pinkAccent.withOpacity(0.05)],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius + 20))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-angle * 0.3 - 1.0);
    canvas.scale(0.9, 0.3);
    canvas.drawCircle(Offset.zero, radius + 20, orbit2Paint);
    
    // Draw orbital glowing dot 2
    final dot2Paint = Paint()
      ..color = Colors.pinkAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset((radius + 20) * math.cos(-angle * 1.5), (radius + 20) * math.sin(-angle * 1.5)), 4, dot2Paint);
    canvas.restore();
    
    // Draw glowing orbit circles 3 (center halo)
    final haloPaint = Paint()
      ..color = Colors.purpleAccent.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 58, haloPaint);
  }

  @override
  bool shouldRepaint(covariant HologramOrbitPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.radius != radius;
  }
}
