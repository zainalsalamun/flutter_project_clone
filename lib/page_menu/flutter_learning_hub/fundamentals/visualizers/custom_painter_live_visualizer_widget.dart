import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomPainterLiveVisualizerWidget extends StatefulWidget {
  const CustomPainterLiveVisualizerWidget({super.key});

  @override
  State<CustomPainterLiveVisualizerWidget> createState() =>
      _CustomPainterLiveVisualizerWidgetState();
}

class _CustomPainterLiveVisualizerWidgetState
    extends State<CustomPainterLiveVisualizerWidget> {
  int _activeMode = 0; // 0: Bezier Curve, 1: Circular Gauge

  // Bezier Control Points
  double _controlPointY = 40.0;
  double _controlPointX = 140.0;

  // Gauge Controls
  double _gaugeProgress = 0.72; // 0.0 to 1.0

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Icon(Icons.brush_rounded, color: Color(0xFFF472B6), size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Simulator Canvas & CustomPainter Live',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Mode Selector
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _activeMode = 0),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeMode == 0 ? const Color(0xFFDB2777) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _activeMode == 0 ? const Color(0xFFF472B6) : const Color(0xFF334155),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '1. Quadratic Bezier Curve',
                      style: TextStyle(
                        color: _activeMode == 0 ? Colors.white : Colors.white70,
                        fontSize: 11.5,
                        fontWeight: _activeMode == 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => _activeMode = 1),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeMode == 1 ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _activeMode == 1 ? const Color(0xFF38BDF8) : const Color(0xFF334155),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '2. Circular Gauge Meter',
                      style: TextStyle(
                        color: _activeMode == 1 ? Colors.white : Colors.white70,
                        fontSize: 11.5,
                        fontWeight: _activeMode == 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Live Canvas Container
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF020617),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: _activeMode == 0
                    ? _BezierPainter(controlX: _controlPointX, controlY: _controlPointY)
                    : _GaugePainter(progress: _gaugeProgress),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Interactive Controls
          if (_activeMode == 0) ...[
            Text(
              'Titik Kontrol X: ${_controlPointX.toStringAsFixed(0)} px | Y: ${_controlPointY.toStringAsFixed(0)} px',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontFamily: 'monospace'),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
                activeTrackColor: const Color(0xFFF472B6),
                thumbColor: const Color(0xFFF472B6),
              ),
              child: Column(
                children: [
                  Slider(
                    value: _controlPointX.clamp(20.0, 260.0),
                    min: 20.0,
                    max: 260.0,
                    onChanged: (v) => setState(() => _controlPointX = v),
                  ),
                  Slider(
                    value: _controlPointY.clamp(10.0, 140.0),
                    min: 10.0,
                    max: 140.0,
                    onChanged: (v) => setState(() => _controlPointY = v),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              'Persentase Gauge: ${(_gaugeProgress * 100).toStringAsFixed(0)}%',
              style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
                activeTrackColor: const Color(0xFF38BDF8),
                thumbColor: const Color(0xFF38BDF8),
              ),
              child: Slider(
                value: _gaugeProgress.clamp(0.0, 1.0),
                min: 0.0,
                max: 1.0,
                onChanged: (v) => setState(() => _gaugeProgress = v),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BezierPainter extends CustomPainter {
  final double controlX;
  final double controlY;

  _BezierPainter({required this.controlX, required this.controlY});

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(30, size.height - 30);
    final end = Offset(size.width - 30, size.height - 30);
    final control = Offset(controlX.clamp(10, size.width - 10), controlY.clamp(10, size.height - 10));

    // Draw Guide Lines (Control Handle)
    final guidePaint = Paint()
      ..color = const Color(0xFF475569)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, control, guidePaint);
    canvas.drawLine(control, end, guidePaint);

    // Draw Bezier Path
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

    final curvePaint = Paint()
      ..color = const Color(0xFFF472B6)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, curvePaint);

    // Draw Anchor Points
    final pointPaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawCircle(start, 5, pointPaint);
    canvas.drawCircle(end, 5, pointPaint);

    // Draw Control Point Handle
    final handlePaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(control, 7, handlePaint);
  }

  @override
  bool shouldRepaint(covariant _BezierPainter oldDelegate) {
    return oldDelegate.controlX != controlX || oldDelegate.controlY != controlY;
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;

  _GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 15);
    final radius = math.min(size.width, size.height) / 2 - 20;

    const startAngle = math.pi * 0.8;
    const sweepAngle = math.pi * 1.4;

    // Track Background
    final trackPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Active Progress Arc
    final activePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF06B6D4), Color(0xFF3B82F6), Color(0xFF8B5CF6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final curSweep = sweepAngle * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      curSweep,
      false,
      activePaint,
    );

    // Text Indicator in Center
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2 - 5),
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
