import 'package:flutter/material.dart';

/// Interactive vector animated illustration of a Train Station & Railroad Crossing
/// Features:
/// 1. Flashing dual red warning signals (alternating left-right with soft neon bloom)
/// 2. Animated barrier gate (palang pintu rel kereta api bergaris hitam-kuning)
/// 3. High-speed passenger train zooming across the tracks in the background
/// 4. Drifting station clouds & subtle track gravel shadows
class RailroadCrossingVisualizer extends StatefulWidget {
  final bool isQueueActive;

  const RailroadCrossingVisualizer({
    super.key,
    this.isQueueActive = true,
  });

  @override
  State<RailroadCrossingVisualizer> createState() =>
      _RailroadCrossingVisualizerState();
}

class _RailroadCrossingVisualizerState extends State<RailroadCrossingVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _blinkerController;
  late AnimationController _trainController;
  late AnimationController _gateBouncingController;
  late AnimationController _cloudController;

  @override
  void initState() {
    super.initState();

    // 1. Dual warning light blinking (1.2s loop)
    _blinkerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // 2. Train passing loop (every 7 seconds)
    _trainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: false);

    // 3. Subtle barrier gate breathing / bounce
    _gateBouncingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // 4. Drifting background clouds
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _blinkerController.dispose();
    _trainController.dispose();
    _gateBouncingController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      height: 185,
      decoration: BoxDecoration(
        color: const Color(0xFFDFE6ED), // Soft slate background
        borderRadius: BorderRadius.circular(38),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D253C).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _blinkerController,
          _trainController,
          _gateBouncingController,
          _cloudController,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: _RailroadCrossingPainter(
              blinkProgress: _blinkerController.value,
              trainProgress: _trainController.value,
              gateBounce: _gateBouncingController.value,
              cloudProgress: _cloudController.value,
            ),
            size: const Size(290, 185),
          );
        },
      ),
    );
  }
}

class _RailroadCrossingPainter extends CustomPainter {
  final double blinkProgress;
  final double trainProgress;
  final double gateBounce;
  final double cloudProgress;

  _RailroadCrossingPainter({
    required this.blinkProgress,
    required this.trainProgress,
    required this.gateBounce,
    required this.cloudProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Sky & Soft Clouds
    _drawSkyAndClouds(canvas, size);

    // 2. Draw Station Shelter & Canopy in Background
    _drawStationCanopy(canvas, size);

    // 3. Draw Passing Train
    _drawPassingTrain(canvas, size);

    // 4. Draw Platform, Track Ground & Road
    _drawGroundAndTracks(canvas, size);

    // 5. Draw Railroad Crossing Signal Pole & Blinking Lights
    _drawCrossingSignalPole(canvas, size);

    // 6. Draw Barrier Arm (Palang Pintu Bergaris) & Bollard
    _drawBarrierGate(canvas, size);
  }

  void _drawSkyAndClouds(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = const Color(0xFFEAF0F6).withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    // Cloud 1
    final c1X = (size.width * cloudProgress + 30) % (size.width + 80) - 40;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c1X, 35), width: 70, height: 22),
      cloudPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c1X + 15, 30), width: 45, height: 26),
      cloudPaint,
    );

    // Cloud 2
    final c2X =
        (size.width * ((cloudProgress + 0.5) % 1.0) + 60) % (size.width + 100) -
            50;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(c2X, 55), width: 90, height: 25),
      cloudPaint,
    );
  }

  void _drawStationCanopy(Canvas canvas, Size size) {
    final stationRoofPaint = Paint()
      ..color = const Color(0xFFB0BDCB)
      ..style = PaintingStyle.fill;

    final stationPillarsPaint = Paint()
      ..color = const Color(0xFF98A6B7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    // Station Roof (Trapezoid canopy)
    final roofPath = Path()
      ..moveTo(110, 54)
      ..lineTo(260, 54)
      ..lineTo(250, 60)
      ..lineTo(120, 60)
      ..close();
    canvas.drawPath(roofPath, stationRoofPaint);

    // Platform roof beams
    canvas.drawRect(
      const Rect.fromLTWH(118, 60, 134, 4),
      Paint()..color = const Color(0xFF8696A8),
    );

    // Vertical Support Pillars
    canvas.drawLine(
        const Offset(135, 64), const Offset(135, 125), stationPillarsPaint);
    canvas.drawLine(
        const Offset(185, 64), const Offset(185, 125), stationPillarsPaint);
    canvas.drawLine(
        const Offset(235, 64), const Offset(235, 125), stationPillarsPaint);

    // Platform Bench / Waiting Area Shelter
    final benchPaint = Paint()
      ..color = const Color(0xFFC0CDDB)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(145, 114, 80, 8),
        const Radius.circular(2),
      ),
      benchPaint,
    );
  }

  void _drawPassingTrain(Canvas canvas, Size size) {
    // Train moves across from left to right between 0.1 and 0.8 progress
    final tProgress = (trainProgress * 1.4) - 0.2;
    final trainX = size.width * tProgress;

    canvas.save();
    // Clip train area above tracks
    canvas.clipRect(Rect.fromLTWH(0, 60, size.width, 70));

    // Train Body (Modern Indonesian Passenger Train - White, Blue & Orange Accent)
    final trainPaint = Paint()..color = const Color(0xFFF7FAFC);
    final blueStripePaint = Paint()..color = const Color(0xFF1E5BB6);
    final orangeStripePaint = Paint()..color = const Color(0xFFFF7A00);
    final windowPaint = Paint()..color = const Color(0xFF2C3E50);

    const trainWidth = 220.0;
    const trainHeight = 36.0;
    final trainTop = 86.0;

    // Draw Train Car
    final trainRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(trainX, trainTop, trainWidth, trainHeight),
      topRight: const Radius.circular(12),
      bottomRight: const Radius.circular(4),
      topLeft: const Radius.circular(12),
      bottomLeft: const Radius.circular(4),
    );
    canvas.drawRRect(trainRect, trainPaint);

    // Train Blue & Orange Stripes
    canvas.drawRect(
      Rect.fromLTWH(trainX, trainTop + 18, trainWidth, 5),
      blueStripePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(trainX, trainTop + 24, trainWidth, 2.5),
      orangeStripePaint,
    );

    // Train Windows
    for (int i = 0; i < 6; i++) {
      final winX = trainX + 20 + (i * 32);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(winX, trainTop + 6, 20, 10),
          const Radius.circular(3),
        ),
        windowPaint,
      );
    }

    // Train Headlight Glow
    if (trainX < size.width) {
      final headlightGlow = Paint()
        ..color = const Color(0xFFFFE082).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(trainX + trainWidth - 2, trainTop + 24), 6, headlightGlow);
    }

    canvas.restore();
  }

  void _drawGroundAndTracks(Canvas canvas, Size size) {
    // 1. Concrete platform / track ballast
    final trackBasePaint = Paint()..color = const Color(0xFFBCC7D3);
    canvas.drawRect(
      Rect.fromLTWH(0, 122, size.width, 10),
      trackBasePaint,
    );

    // Track rails (thin silver line)
    final railPaint = Paint()
      ..color = const Color(0xFF8697A8)
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(0, 124), Offset(size.width, 124), railPaint);
    canvas.drawLine(const Offset(0, 131), Offset(size.width, 131), railPaint);

    // 2. Asphalt Road foreground
    final roadPaint = Paint()..color = const Color(0xFFCBD6E2);
    canvas.drawRect(
      Rect.fromLTWH(0, 132, size.width, size.height - 132),
      roadPaint,
    );

    // Road subtle horizon line
    canvas.drawLine(
      const Offset(0, 132),
      Offset(size.width, 132),
      Paint()
        ..color = const Color(0xFFA5B4C4)
        ..strokeWidth = 1.5,
    );
  }

  void _drawCrossingSignalPole(Canvas canvas, Size size) {
    const poleX = 105.0;

    // Pole Base / Stand
    final basePaint = Paint()..color = const Color(0xFF7A8B9E);
    final baseRect = Path()
      ..moveTo(poleX - 12, 142)
      ..lineTo(poleX + 12, 142)
      ..lineTo(poleX + 7, 120)
      ..lineTo(poleX - 7, 120)
      ..close();
    canvas.drawPath(baseRect, basePaint);

    // Vertical Metal Pole
    final polePaint = Paint()
      ..color = const Color(0xFF8D9CAE)
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(poleX, 120), const Offset(poleX, 48), polePaint);

    // --- A. CROSSBUCK SIGN ("X") ---
    canvas.save();
    canvas.translate(poleX, 54);

    final crossSignBorder = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.square;

    final crossSignFill = Paint()
      ..color = const Color(0xFFFFD54F) // Railway Yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.square;

    // Arm 1 (\)
    canvas.drawLine(const Offset(-16, -12), const Offset(16, 12), crossSignBorder);
    canvas.drawLine(const Offset(-16, -12), const Offset(16, 12), crossSignFill);

    // Arm 2 (/)
    canvas.drawLine(const Offset(-16, 12), const Offset(16, -12), crossSignBorder);
    canvas.drawLine(const Offset(-16, 12), const Offset(16, -12), crossSignFill);

    // Red Warning Hazard Symbol in Center of Cross
    final hazardBg = Paint()..color = const Color(0xFFD32F2F);
    canvas.drawCircle(Offset.zero, 4.5, hazardBg);
    final hazardInner = Paint()..color = Colors.white;
    canvas.drawCircle(Offset.zero, 2.0, hazardInner);

    canvas.restore();

    // --- B. DUAL RED BLINKING SIGNAL LIGHTS ---
    const lightBarY = 94.0;

    // Horizontal crossbar for lights
    final barPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 3.5;
    canvas.drawLine(
      const Offset(poleX - 20, lightBarY),
      const Offset(poleX + 20, lightBarY),
      barPaint,
    );

    // Alternating flash: left on when blinkProgress < 0.5, right on when blinkProgress >= 0.5
    final isLeftOn = blinkProgress < 0.5;
    final isRightOn = !isLeftOn;

    _drawSignalLight(canvas, const Offset(poleX - 16, lightBarY), isLeftOn);
    _drawSignalLight(canvas, const Offset(poleX + 16, lightBarY), isRightOn);
  }

  void _drawSignalLight(Canvas canvas, Offset position, bool isOn) {
    // Housing Black Disc
    final housingPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawCircle(position, 8.5, housingPaint);

    if (isOn) {
      // Glow Aura
      final glowPaint = Paint()
        ..color = const Color(0xFFFF1744).withValues(alpha: 0.55)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(position, 12, glowPaint);

      // Bright Core Red
      final redCore = Paint()..color = const Color(0xFFFF1744);
      canvas.drawCircle(position, 6, redCore);

      // White Hot Center
      final whiteCenter = Paint()..color = const Color(0xFFFFCDD2);
      canvas.drawCircle(position, 2.5, whiteCenter);
    } else {
      // Off / Dim Dark Red
      final dimPaint = Paint()..color = const Color(0xFF5A1A1A);
      canvas.drawCircle(position, 6, dimPaint);
    }
  }

  void _drawBarrierGate(Canvas canvas, Size size) {
    const pivotX = 108.0;
    const pivotY = 135.0;
    final bounceAngle = (gateBounce - 0.5) * 0.04; // subtle animated bounce

    canvas.save();
    canvas.translate(pivotX, pivotY);
    canvas.rotate(bounceAngle);

    // Gate Arm dimensions
    const armLength = 110.0;
    const armHeight = 8.5;

    // 1. Black/Dark Background Bar
    final armBgPaint = Paint()..color = const Color(0xFF2C3E50);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, -armHeight / 2, armLength, armHeight),
        const Radius.circular(2),
      ),
      armBgPaint,
    );

    // 2. Yellow Diagonal Caution Stripes
    final stripePaint = Paint()..color = const Color(0xFFFFC107);
    const stripeWidth = 10.0;
    const stripeGap = 18.0;

    for (double x = 4; x < armLength - 6; x += stripeGap) {
      final stripePath = Path()
        ..moveTo(x, -armHeight / 2)
        ..lineTo(x + stripeWidth, -armHeight / 2)
        ..lineTo(x + stripeWidth - 4, armHeight / 2)
        ..lineTo(x - 4, armHeight / 2)
        ..close();
      canvas.drawPath(stripePath, stripePaint);
    }

    // 3. Small Red Blinking LED on Gate Tip
    final isGateLightOn = blinkProgress < 0.5;
    final tipPos = const Offset(armLength - 5, 0);
    if (isGateLightOn) {
      canvas.drawCircle(
        tipPos,
        5,
        Paint()
          ..color = const Color(0xFFFF3D00).withValues(alpha: 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      canvas.drawCircle(tipPos, 3, Paint()..color = const Color(0xFFFF5252));
    } else {
      canvas.drawCircle(tipPos, 2.5, Paint()..color = const Color(0xFF6B2B2B));
    }

    canvas.restore();

    // 4. Bollard / Support Post on the Right
    const bollardX = 180.0;
    final bollardPaint = Paint()..color = const Color(0xFF475569);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(bollardX, 134, 7, 24),
        const Radius.circular(2),
      ),
      bollardPaint,
    );
    // Yellow stripe on bollard
    canvas.drawRect(
      const Rect.fromLTWH(bollardX, 142, 7, 4),
      Paint()..color = const Color(0xFFFFD54F),
    );
  }

  @override
  bool shouldRepaint(covariant _RailroadCrossingPainter oldDelegate) {
    return oldDelegate.blinkProgress != blinkProgress ||
        oldDelegate.trainProgress != trainProgress ||
        oldDelegate.gateBounce != gateBounce ||
        oldDelegate.cloudProgress != cloudProgress;
  }
}
