import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularGradientProgressShowcase extends StatefulWidget {
  const CircularGradientProgressShowcase({super.key});

  @override
  State<CircularGradientProgressShowcase> createState() =>
      _CircularGradientProgressShowcaseState();
}

class _CircularGradientProgressShowcaseState
    extends State<CircularGradientProgressShowcase> {
  double _progress = 0.72;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularGradientIndicator(
              progress: _progress,
              size: 110,
              strokeWidth: 10,
              gradient: const SweepGradient(
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFFEC4899),
                  Color(0xFF6366F1),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_progress * 100).round()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'GOAL',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            CircularGradientIndicator(
              progress: (_progress * 0.85).clamp(0.0, 1.0),
              size: 110,
              strokeWidth: 10,
              gradient: const SweepGradient(
                colors: [
                  Color(0xFF10B981),
                  Color(0xFF06B6D4),
                  Color(0xFF10B981),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.fitness_center_rounded,
                    color: Color(0xFF10B981),
                    size: 22,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${((_progress * 0.85) * 1000).round()} kcal',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Slider(
          value: _progress,
          activeColor: const Color(0xFF6366F1),
          onChanged: (val) => setState(() => _progress = val),
        ),
        Text(
          'Drag slider to adjust percentage (${(_progress * 100).round()}%)',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}

class CircularGradientIndicator extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Gradient gradient;
  final Widget? child;

  const CircularGradientIndicator({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    required this.gradient,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _GradientArcPainter(
              progress: progress,
              strokeWidth: strokeWidth,
              gradient: gradient,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

class _GradientArcPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Gradient gradient;

  _GradientArcPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    final trackPaint =
        Paint()
          ..color = Colors.grey.shade200
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final progressPaint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      rect,
      -math.pi / 2, // Start at top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
