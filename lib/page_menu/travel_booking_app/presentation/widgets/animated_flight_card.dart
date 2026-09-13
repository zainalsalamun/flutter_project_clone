import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../core/utils/travel_currency.dart';
import '../../data/models/travel_item_model.dart';

class AnimatedFlightCard extends StatefulWidget {
  final FlightTicket flight;
  final VoidCallback? onTap;
  final void Function(GlobalKey key)? onTapWithKey;

  const AnimatedFlightCard({
    super.key,
    required this.flight,
    this.onTap,
    this.onTapWithKey,
  });

  @override
  State<AnimatedFlightCard> createState() => _AnimatedFlightCardState();
}

class _AnimatedFlightCardState extends State<AnimatedFlightCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey _cardKey = GlobalKey();
  bool _isPressed = false;
  late AnimationController _flightAnimController;

  @override
  void initState() {
    super.initState();
    _flightAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _flightAnimController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTapWithKey != null) {
      widget.onTapWithKey!(_cardKey);
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _cardKey,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapCancel: () => setState(() => _isPressed = false),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        Future.delayed(const Duration(milliseconds: 60), _handleTap);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: TravelTheme.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: TravelTheme.dark.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Airline Header
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: TravelTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.flight_takeoff_rounded,
                      color: TravelTheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.flight.airlineName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: TravelTheme.dark,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.flight.flightNumber,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: TravelTheme.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: TravelTheme.primaryLight.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.flight.cabinClass,
                      style: const TextStyle(
                        color: TravelTheme.primaryLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Route & Timings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Origin
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.flight.originCode,
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        widget.flight.departureTime,
                        style: const TextStyle(
                          color: TravelTheme.darkMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.flight.originCity,
                        style: const TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Flight Duration Path
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Text(
                            widget.flight.duration,
                            style: const TextStyle(
                              color: TravelTheme.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedBuilder(
                            animation: _flightAnimController,
                            builder: (context, child) {
                              return CustomPaint(
                                size: const Size(double.infinity, 20),
                                painter: _AnimatedRunningFlightPathPainter(
                                  animationValue: _flightAnimController.value,
                                  primaryColor: TravelTheme.primary,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${widget.flight.baggageKg} Kg Bagasi',
                            style: const TextStyle(
                              color: TravelTheme.emerald,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Destination
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.flight.destinationCode,
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        widget.flight.arrivalTime,
                        style: const TextStyle(
                          color: TravelTheme.darkMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.flight.destinationCity,
                        style: const TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: TravelTheme.surface, height: 1),
              const SizedBox(height: 12),

              // Bottom Price & Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total per penumpang',
                        style: TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatTravelCurrency(widget.flight.price),
                        style: const TextStyle(
                          color: TravelTheme.accent,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: TravelTheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Pilih Tiket',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Animated Flight Path & Real-time Airplane Flying Along Curve
class _AnimatedRunningFlightPathPainter extends CustomPainter {
  final double animationValue; // 0.0 -> 1.0 continuous loop
  final Color primaryColor;

  _AnimatedRunningFlightPathPainter({
    required this.animationValue,
    this.primaryColor = TravelTheme.primary,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Flight Arc Trajectory: Smooth arching curve from origin to destination
    final start = Offset(4, h - 3);
    final end = Offset(w - 4, h - 3);
    final control = Offset(w / 2, -1);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

    final pathMetrics = path.computeMetrics().first;
    final pathLength = pathMetrics.length;

    // 1. Soft dashed arc flight path (Background trajectory)
    final dashPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.5;
    const dashSpace = 3.0;
    double distance = 0.0;
    while (distance < pathLength) {
      final extractLength = (distance + dashWidth < pathLength) ? dashWidth : pathLength - distance;
      final metricPath = pathMetrics.extractPath(distance, distance + extractLength);
      canvas.drawPath(metricPath, dashPaint);
      distance += dashWidth + dashSpace;
    }

    // 2. Traversed flight path in glowing primary color
    final currentDist = animationValue * pathLength;
    if (currentDist > 0) {
      final traversedPath = pathMetrics.extractPath(0, currentDist);
      final glowPaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.45)
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke;
      canvas.drawPath(traversedPath, glowPaint);
    }

    // 3. Origin & Destination Airport Station Pins
    final pinPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    final pinRingPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(start, 4.5, pinRingPaint);
    canvas.drawCircle(start, 2.2, pinPaint);

    canvas.drawCircle(end, 4.5, pinRingPaint);
    canvas.drawCircle(end, 2.2, pinPaint);

    // 4. Calculate Airplane Position & Heading along the curve
    final tangent = pathMetrics.getTangentForOffset(currentDist);
    if (tangent != null) {
      final pos = tangent.position;
      final angle = tangent.angle;

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(angle);

      // Jet Engine Contrail / Vapor Trail behind airplane
      final trailPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            primaryColor.withValues(alpha: 0.3),
            primaryColor.withValues(alpha: 0.8),
          ],
        ).createShader(const Rect.fromLTWH(-20, -1.2, 20, 2.4))
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(const Offset(-18, 0), const Offset(-2, 0), trailPaint);

      // Draw Airplane Shape (Aerodynamic commercial jet facing right ➔)
      final planePaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;

      final bodyPath = Path();
      bodyPath.moveTo(8.5, 0); // Nose
      bodyPath.lineTo(4, -1.8);
      bodyPath.lineTo(-0.5, -7.5); // Top wing tip
      bodyPath.lineTo(-2.2, -7.5);
      bodyPath.lineTo(-2.2, -1.8);
      bodyPath.lineTo(-6.5, -1.8);
      bodyPath.lineTo(-8.5, -4.5); // Tail fin top
      bodyPath.lineTo(-9.5, -4.5);
      bodyPath.lineTo(-8.0, 0); // Tail rear
      bodyPath.lineTo(-9.5, 4.5); // Tail fin bottom
      bodyPath.lineTo(-8.5, 4.5);
      bodyPath.lineTo(-6.5, 1.8);
      bodyPath.lineTo(-2.2, 1.8);
      bodyPath.lineTo(-2.2, 7.5);
      bodyPath.lineTo(-0.5, 7.5); // Bottom wing tip
      bodyPath.lineTo(4, 1.8);
      bodyPath.close();

      canvas.drawPath(bodyPath, planePaint);

      // Cockpit Window
      final windowPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(4.0, -0.4), 0.9, windowPaint);

      // Wingtip Navigation Lights (Red left / Green right)
      final leftNavPaint = Paint()..color = const Color(0xFFEF4444);
      final rightNavPaint = Paint()..color = const Color(0xFF10B981);
      canvas.drawCircle(const Offset(-1.5, -7.0), 0.9, leftNavPaint);
      canvas.drawCircle(const Offset(-1.5, 7.0), 0.9, rightNavPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedRunningFlightPathPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
