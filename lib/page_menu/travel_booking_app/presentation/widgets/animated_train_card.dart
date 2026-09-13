import 'package:flutter/material.dart';
import '../../core/theme/travel_theme.dart';
import '../../core/utils/travel_currency.dart';
import '../../data/models/travel_item_model.dart';

class AnimatedTrainCard extends StatefulWidget {
  final TrainTicket train;
  final VoidCallback? onTap;
  final void Function(GlobalKey key)? onTapWithKey;

  const AnimatedTrainCard({
    super.key,
    required this.train,
    this.onTap,
    this.onTapWithKey,
  });

  @override
  State<AnimatedTrainCard> createState() => _AnimatedTrainCardState();
}

class _AnimatedTrainCardState extends State<AnimatedTrainCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey _cardKey = GlobalKey();
  bool _isPressed = false;
  late AnimationController _trackAnimController;

  @override
  void initState() {
    super.initState();
    final durationMs = widget.train.speedText.contains('350') ? 1900 : 2800;
    _trackAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    )..repeat();
  }

  @override
  void dispose() {
    _trackAnimController.dispose();
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
              // Train Name & Class Header
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.train_rounded,
                      color: Color(0xFF0284C7),
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.train.trainName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: TravelTheme.dark,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          widget.train.trainNumber,
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
                      color: TravelTheme.emerald.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.train.trainClass,
                      style: const TextStyle(
                        color: TravelTheme.emerald,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Route & Timings with Animated Moving Tracks
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Origin Station
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.train.originCode,
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        widget.train.departureTime,
                        style: const TextStyle(
                          color: TravelTheme.darkMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.train.originCity,
                        style: const TextStyle(
                          color: TravelTheme.muted,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Animated Railway Track
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          Text(
                            widget.train.duration,
                            style: const TextStyle(
                              color: TravelTheme.muted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedBuilder(
                            animation: _trackAnimController,
                            builder: (context, child) {
                              return CustomPaint(
                                size: const Size(double.infinity, 18),
                                painter: _AnimatedRunningTrainTrackPainter(
                                  animationValue: _trackAnimController.value,
                                  isHighSpeed: widget.train.speedText.contains('350'),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '⚡ ${widget.train.speedText}',
                              style: const TextStyle(
                                color: Color(0xFF0284C7),
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Destination Station
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.train.destinationCode,
                        style: const TextStyle(
                          color: TravelTheme.dark,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        widget.train.arrivalTime,
                        style: const TextStyle(
                          color: TravelTheme.darkMuted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.train.destinationCity,
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

              const SizedBox(height: 12),

              // Transit Stops Preview
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(Icons.directions_railway_rounded, size: 14, color: TravelTheme.muted),
                    const SizedBox(width: 6),
                    Text(
                      'Rute: ${widget.train.transitStops.join(" ➔ ")}',
                      style: const TextStyle(
                        color: TravelTheme.muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              const Divider(color: TravelTheme.surface, height: 1),
              const SizedBox(height: 12),

              // Bottom Price & Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.train.wagonInfo,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: TravelTheme.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          formatTravelCurrency(widget.train.price),
                          style: const TextStyle(
                            color: Color(0xFF0284C7),
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Pilih Kereta',
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

// Custom Painter for Animated Railway Track & Running Train
class _AnimatedRunningTrainTrackPainter extends CustomPainter {
  final double animationValue; // 0.0 -> 1.0 continuous loop
  final bool isHighSpeed;

  _AnimatedRunningTrainTrackPainter({
    required this.animationValue,
    this.isHighSpeed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trackY = size.height * 0.58;
    const railHeight = 5.0;
    final topRailY = trackY - railHeight / 2;
    final bottomRailY = trackY + railHeight / 2;

    // 1. Railroad ties (sleepers) underneath
    final sleeperPaint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.5)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    const spacing = 8.5;
    final tieOffset = (animationValue * spacing) % spacing;

    for (double x = -spacing + tieOffset; x <= size.width + spacing; x += spacing) {
      if (x >= 2 && x <= size.width - 2) {
        canvas.drawLine(
          Offset(x, topRailY - 2.5),
          Offset(x, bottomRailY + 2.5),
          sleeperPaint,
        );
      }
    }

    // 2. Dual Steel Rails (Horizontal lines)
    final railPaint = Paint()
      ..color = const Color(0xFF64748B).withValues(alpha: 0.8)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, topRailY), Offset(size.width, topRailY), railPaint);
    canvas.drawLine(Offset(0, bottomRailY), Offset(size.width, bottomRailY), railPaint);

    // 3. Station terminal endpoints (Dots on both ends)
    final terminalPaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, trackY), 2.5, terminalPaint);
    canvas.drawCircle(Offset(size.width, trackY), 2.5, terminalPaint);

    // 4. Moving Train Calculation
    const trainWidth = 26.0;
    const trainHeight = 10.0;
    // Glides continuously from -trainWidth to size.width + 12
    final totalDistance = size.width + trainWidth + 12;
    final trainX = -trainWidth + (animationValue * totalDistance);
    final trainY = trackY - trainHeight / 2;

    if (trainX + trainWidth >= 0 && trainX <= size.width) {
      // Forward Headlight Beam illuminating track
      final beamLength = isHighSpeed ? 28.0 : 20.0;
      final beamStart = trainX + trainWidth;
      final beamPath = Path()
        ..moveTo(beamStart, trackY - 1)
        ..lineTo(beamStart + beamLength, trackY - 5)
        ..lineTo(beamStart + beamLength, trackY + 5)
        ..lineTo(beamStart, trackY + 1)
        ..close();

      final beamPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            const Color(0xFFFDE047).withValues(alpha: 0.6),
            const Color(0xFFFDE047).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(beamStart, trackY - 5, beamLength, 10))
        ..style = PaintingStyle.fill;
      canvas.drawPath(beamPath, beamPaint);

      // Speed Trail / Aerodynamic Glow behind train
      if (trainX > -trainWidth) {
        final trailLength = isHighSpeed ? 24.0 : 16.0;
        final trailRect = Rect.fromLTWH(trainX - trailLength, trackY - 2.5, trailLength, 5);
        final trailPaint = Paint()
          ..shader = LinearGradient(
            colors: [
              const Color(0xFF0284C7).withValues(alpha: 0.0),
              (isHighSpeed ? const Color(0xFF38BDF8) : const Color(0xFF0284C7)).withValues(alpha: 0.45),
            ],
          ).createShader(trailRect);
        canvas.drawRRect(
          RRect.fromRectAndRadius(trailRect, const Radius.circular(2.5)),
          trailPaint,
        );
      }

      // Train Body (Aerodynamic bullet train capsule)
      final trainRect = Rect.fromLTWH(trainX, trainY, trainWidth, trainHeight);
      final bodyRRect = RRect.fromRectAndCorners(
        trainRect,
        topLeft: const Radius.circular(2.5),
        bottomLeft: const Radius.circular(2.5),
        topRight: const Radius.circular(7),
        bottomRight: const Radius.circular(7),
      );

      final bodyPaint = Paint()
        ..shader = LinearGradient(
          colors: isHighSpeed
              ? [const Color(0xFF0369A1), const Color(0xFF0284C7)]
              : [const Color(0xFF1E293B), const Color(0xFF0284C7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(trainRect);
      canvas.drawRRect(bodyRRect, bodyPaint);

      // White Speed Stripe along train middle
      final stripePaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 1.0;
      canvas.drawLine(
        Offset(trainX + 2, trackY),
        Offset(trainX + trainWidth - 4, trackY),
        stripePaint,
      );

      // Windows (3 small light-blue rectangles)
      final windowPaint = Paint()
        ..color = const Color(0xFFE0F2FE)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(trainX + 3.5, trainY + 1.8, 3.8, 2.8),
          const Radius.circular(0.8),
        ),
        windowPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(trainX + 9.5, trainY + 1.8, 3.8, 2.8),
          const Radius.circular(0.8),
        ),
        windowPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(trainX + 15.5, trainY + 1.8, 4.8, 2.8),
          const Radius.circular(1.2),
        ),
        windowPaint,
      );

      // Headlight (Yellow LED at train nose)
      final headlightPaint = Paint()
        ..color = const Color(0xFFFDE047)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(trainX + trainWidth - 1.2, trackY), 1.3, headlightPaint);

      // Red Tail Light at back
      final tailPaint = Paint()
        ..color = const Color(0xFFEF4444)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(trainX + 1.2, trackY), 1.0, tailPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedRunningTrainTrackPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
