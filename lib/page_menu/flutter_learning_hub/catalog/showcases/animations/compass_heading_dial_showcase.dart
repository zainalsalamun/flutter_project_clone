import 'dart:math' as math;
import 'package:flutter/material.dart';

class CompassHeadingDialShowcase extends StatefulWidget {
  const CompassHeadingDialShowcase({super.key});

  @override
  State<CompassHeadingDialShowcase> createState() =>
      _CompassHeadingDialShowcaseState();
}

class _CompassHeadingDialShowcaseState extends State<CompassHeadingDialShowcase>
    with SingleTickerProviderStateMixin {
  double _headingDegrees = 42.0; // 0 to 360
  bool _isAutoScanning = false;
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.linear),
    )..addListener(() {
      if (_isAutoScanning) {
        setState(() {
          _headingDegrees = _scanAnimation.value % 360.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _toggleAutoScan() {
    setState(() {
      _isAutoScanning = !_isAutoScanning;
    });
    if (_isAutoScanning) {
      _scanController.repeat();
    } else {
      _scanController.stop();
    }
  }

  String _getCardinalDirection(double deg) {
    const directions = [
      'UTARA (N)',
      'TIMUR LAUT (NE)',
      'TIMUR (E)',
      'TENGGARA (SE)',
      'SELATAN (S)',
      'BARAT DAYA (SW)',
      'BARAT (W)',
      'BARAT LAUT (NW)',
    ];
    final index = (((deg + 22.5) % 360) / 45).floor();
    return directions[index];
  }

  @override
  Widget build(BuildContext context) {
    final cardinal = _getCardinalDirection(_headingDegrees);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. TACTICAL COMPASS STAGE ----------------
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top Heading Readout Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.navigation_rounded,
                      size: 16,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_headingDegrees.toInt()}° $cardinal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Interactive 360 Compass Dial Canvas
              SizedBox(
                width: 210,
                height: 210,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final center = Offset(
                      constraints.maxWidth / 2,
                      constraints.maxHeight / 2,
                    );
                    return GestureDetector(
                      onPanUpdate: (details) {
                        final touchPos = details.localPosition;
                        final dx = touchPos.dx - center.dx;
                        final dy = touchPos.dy - center.dy;
                        var angleRad = math.atan2(dy, dx) + (math.pi / 2);
                        if (angleRad < 0) angleRad += math.pi * 2;
                        final deg = angleRad * 180 / math.pi;

                        setState(() {
                          _isAutoScanning = false;
                          _headingDegrees = deg % 360;
                        });
                      },
                      child: CustomPaint(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        painter: _CompassDialPainter(
                          headingDegrees: _headingDegrees,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              // Tactical Sensor Coordinates Sub-Banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GPS: 6°12\'08" S, 106°49\'48" E',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'ALT: 48m dpl',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. CONTROLS BAR ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sensor Interaktif Kompas',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Putar dial melingkar dengan sentuhan jari',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isAutoScanning
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  visualDensity: VisualDensity.compact,
                  elevation: 0,
                ),
                onPressed: _toggleAutoScan,
                icon: Icon(
                  _isAutoScanning ? Icons.pause_rounded : Icons.explore_rounded,
                  size: 15,
                ),
                label: Text(
                  _isAutoScanning ? 'Stop' : 'Auto Gyro',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// CUSTOM PAINTER FOR 360 COMPASS DIAL & TACTICAL NEEDLE
// ---------------------------------------------------------------------------
class _CompassDialPainter extends CustomPainter {
  final double headingDegrees;

  _CompassDialPainter({required this.headingDegrees});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // 1. Draw Outer Dial Ring
    final dialBgPaint =
        Paint()
          ..color = const Color(0xFF1E293B)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, dialBgPaint);

    final borderPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, borderPaint);

    final headingRad = (headingDegrees * math.pi / 180);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-headingRad); // Rotate dial against heading

    // 2. Draw 72 Graduated Tick Marks (every 5 degrees)
    for (int i = 0; i < 72; i++) {
      final tickAngle = (i * 5) * math.pi / 180;
      final isMajor = i % 6 == 0; // Every 30 deg
      final isCardinal = i % 18 == 0; // Every 90 deg

      final tickLength = isCardinal ? 12.0 : (isMajor ? 8.0 : 4.0);
      final tickPaint =
          Paint()
            ..color =
                isCardinal
                    ? Colors.white
                    : (isMajor ? Colors.white70 : Colors.white30)
            ..strokeWidth = isCardinal ? 2.0 : (isMajor ? 1.5 : 1.0);

      final p1 = Offset(
        math.cos(tickAngle) * (radius - 2),
        math.sin(tickAngle) * (radius - 2),
      );
      final p2 = Offset(
        math.cos(tickAngle) * (radius - 2 - tickLength),
        math.sin(tickAngle) * (radius - 2 - tickLength),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    // 3. Draw Cardinal Text (U, T, S, B)
    _drawCardinalText(
      canvas,
      'U',
      const Offset(0, -74),
      const Color(0xFFEF4444),
    );
    _drawCardinalText(canvas, 'S', const Offset(0, 74), Colors.white70);
    _drawCardinalText(canvas, 'T', const Offset(74, 0), Colors.white70);
    _drawCardinalText(canvas, 'B', const Offset(-74, 0), Colors.white70);

    canvas.restore();

    // 4. Fixed Magnetic Needle in the center pointing North / South
    final needleNorthPath =
        Path()
          ..moveTo(center.dx, center.dy - 65)
          ..lineTo(center.dx + 8, center.dy)
          ..lineTo(center.dx - 8, center.dy)
          ..close();

    final needleSouthPath =
        Path()
          ..moveTo(center.dx, center.dy + 65)
          ..lineTo(center.dx + 8, center.dy)
          ..lineTo(center.dx - 8, center.dy)
          ..close();

    final northPaint =
        Paint()
          ..color = const Color(0xFFEF4444)
          ..style = PaintingStyle.fill;
    final southPaint =
        Paint()
          ..color = Colors.white70
          ..style = PaintingStyle.fill;

    canvas.drawPath(needleNorthPath, northPaint);
    canvas.drawPath(needleSouthPath, southPaint);

    // 5. Central Brass Pivot Knob
    final pivotPaint =
        Paint()
          ..color = const Color(0xFFF59E0B)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 7, pivotPaint);

    final pivotCenterPaint =
        Paint()
          ..color = const Color(0xFF0F172A)
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3, pivotCenterPaint);
  }

  void _drawCardinalText(
    Canvas canvas,
    String text,
    Offset offset,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      offset - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) =>
      oldDelegate.headingDegrees != headingDegrees;
}
