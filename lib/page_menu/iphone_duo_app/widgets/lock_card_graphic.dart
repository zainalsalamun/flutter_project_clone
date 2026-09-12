import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:project_clone/page_menu/iphone_duo_app/models/lock_plan.dart';

class LockCardGraphic extends StatelessWidget {
  final LockType type;
  final double size;

  const LockCardGraphic({
    super.key,
    required this.type,
    this.size = 110,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _getPainter(type),
      ),
    );
  }

  CustomPainter _getPainter(LockType type) {
    switch (type) {
      case LockType.vaultLock:
        return VaultSafePainter();
      case LockType.fixedLock:
        return FixedLockPainter();
      case LockType.targetSavings:
        return TargetSavingsPainter();
    }
  }
}

/// 3D Isometric Vault Safe Painter
class VaultSafePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw shadow underneath
    final shadowPaint = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.52, h * 0.82),
        width: w * 0.75,
        height: h * 0.22,
      ),
      shadowPaint,
    );

    // 3D Isometric Box - Left Face (Front)
    final frontPath = Path()
      ..moveTo(w * 0.25, h * 0.28)
      ..lineTo(w * 0.65, h * 0.18)
      ..lineTo(w * 0.65, h * 0.68)
      ..lineTo(w * 0.25, h * 0.78)
      ..close();

    final frontPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFE2E8F0)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(frontPath, frontPaint);

    // 3D Isometric Box - Right Face (Side Depth)
    final sidePath = Path()
      ..moveTo(w * 0.65, h * 0.18)
      ..lineTo(w * 0.88, h * 0.30)
      ..lineTo(w * 0.88, h * 0.78)
      ..lineTo(w * 0.65, h * 0.68)
      ..close();

    final sidePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFCBD5E1), Color(0xFF94A3B8)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(sidePath, sidePaint);

    // 3D Isometric Box - Top Face
    final topPath = Path()
      ..moveTo(w * 0.25, h * 0.28)
      ..lineTo(w * 0.48, h * 0.16)
      ..lineTo(w * 0.88, h * 0.30)
      ..lineTo(w * 0.65, h * 0.42)
      ..close();

    final topPaint = Paint()
      ..color = const Color(0xFFF8FAFC);
    canvas.drawPath(topPath, topPaint);

    // Safe Door Inset (Front)
    final doorPath = Path()
      ..moveTo(w * 0.30, h * 0.34)
      ..lineTo(w * 0.60, h * 0.26)
      ..lineTo(w * 0.60, h * 0.64)
      ..lineTo(w * 0.30, h * 0.72)
      ..close();

    final doorPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E1)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(doorPath, doorPaint);

    // Keypad Panel (Dark Blue Rect on door)
    final keypadPath = Path()
      ..moveTo(w * 0.34, h * 0.40)
      ..lineTo(w * 0.45, h * 0.37)
      ..lineTo(w * 0.45, h * 0.58)
      ..lineTo(w * 0.34, h * 0.61)
      ..close();

    final keypadPaint = Paint()..color = const Color(0xFF1E293B);
    canvas.drawPath(keypadPath, keypadPaint);

    // Keypad Buttons dots (grid)
    final dotPaint = Paint()..color = const Color(0xFF38BDF8);
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 2; c++) {
        canvas.drawCircle(
          Offset(w * (0.37 + c * 0.04), h * (0.43 + r * 0.05)),
          1.5,
          dotPaint,
        );
      }
    }

    // Vault Rotary Wheel Handle
    final dialCenter = Offset(w * 0.52, h * 0.48);
    final dialPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawCircle(dialCenter, 6.0, dialPaint);

    final innerDialPaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawCircle(dialCenter, 3.0, innerDialPaint);

    // Pin code token / card laying in front
    final tokenPath = Path()
      ..moveTo(w * 0.50, h * 0.76)
      ..lineTo(w * 0.68, h * 0.70)
      ..lineTo(w * 0.75, h * 0.75)
      ..lineTo(w * 0.56, h * 0.81)
      ..close();

    final tokenPaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawPath(tokenPath, tokenPaint);

    // Token dots
    final tokenDotPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(w * (0.55 + i * 0.04), h * (0.75 + i * 0.005)),
        1.2,
        tokenDotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Isometric Fixed Lock Painter
class FixedLockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.58, h * 0.82),
        width: w * 0.7,
        height: h * 0.2,
      ),
      shadowPaint,
    );

    // Metallic Shackle (Silver Arch behind lock body)
    final shacklePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9.0
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final shacklePath = Path()
      ..moveTo(w * 0.60, h * 0.38)
      ..lineTo(w * 0.60, h * 0.24)
      ..arcToPoint(
        Offset(w * 0.76, h * 0.24),
        radius: const Radius.circular(10),
        clockwise: true,
      )
      ..lineTo(w * 0.76, h * 0.42);

    canvas.drawPath(shacklePath, shacklePaint);

    // 3D Padlock Body - Front Face (Purple)
    final bodyFrontPath = Path()
      ..moveTo(w * 0.52, h * 0.36)
      ..lineTo(w * 0.82, h * 0.34)
      ..lineTo(w * 0.82, h * 0.74)
      ..lineTo(w * 0.52, h * 0.76)
      ..close();

    final bodyFrontPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(bodyFrontPath, bodyFrontPaint);

    // 3D Padlock Body - Side Depth (Darker Purple)
    final bodySidePath = Path()
      ..moveTo(w * 0.82, h * 0.34)
      ..lineTo(w * 0.94, h * 0.42)
      ..lineTo(w * 0.94, h * 0.80)
      ..lineTo(w * 0.82, h * 0.74)
      ..close();

    final bodySidePaint = Paint()
      ..color = const Color(0xFF4C1D95);
    canvas.drawPath(bodySidePath, bodySidePaint);

    // Keyhole
    final keyholePaint = Paint()..color = const Color(0xFF2E1065);
    canvas.drawCircle(Offset(w * 0.67, h * 0.52), 4.0, keyholePaint);
    final keyholeSlot = Path()
      ..moveTo(w * 0.65, h * 0.52)
      ..lineTo(w * 0.69, h * 0.52)
      ..lineTo(w * 0.68, h * 0.60)
      ..lineTo(w * 0.66, h * 0.60)
      ..close();
    canvas.drawPath(keyholeSlot, keyholePaint);

    // Golden Key floating in front
    final keyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFDE047), Color(0xFFEAB308), Color(0xFFCA8A04)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Key Head (Ring)
    canvas.drawCircle(Offset(w * 0.28, h * 0.66), 8.0, keyPaint);
    canvas.drawCircle(Offset(w * 0.28, h * 0.66), 4.0, Paint()..color = const Color(0xFF9042F6));

    // Key Shaft
    final shaftPath = Path()
      ..moveTo(w * 0.34, h * 0.64)
      ..lineTo(w * 0.56, h * 0.52)
      ..lineTo(w * 0.58, h * 0.55)
      ..lineTo(w * 0.36, h * 0.67)
      ..close();
    canvas.drawPath(shaftPath, keyPaint);

    // Key Teeth
    final toothPath = Path()
      ..moveTo(w * 0.48, h * 0.56)
      ..lineTo(w * 0.50, h * 0.60)
      ..lineTo(w * 0.53, h * 0.58)
      ..lineTo(w * 0.52, h * 0.54)
      ..close();
    canvas.drawPath(toothPath, keyPaint);

    // Shine sparkles
    final sparklePaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    canvas.drawCircle(Offset(w * 0.24, h * 0.60), 1.5, sparklePaint);
    canvas.drawCircle(Offset(w * 0.36, h * 0.72), 1.0, sparklePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Isometric Target Savings Painter
class TargetSavingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.56, h * 0.84),
        width: w * 0.7,
        height: h * 0.2,
      ),
      shadowPaint,
    );

    // Tripod Legs (Behind)
    final legPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Left leg
    canvas.drawLine(Offset(w * 0.45, h * 0.56), Offset(w * 0.36, h * 0.82), legPaint);
    // Right leg
    canvas.drawLine(Offset(w * 0.66, h * 0.56), Offset(w * 0.76, h * 0.80), legPaint);
    // Center back leg
    canvas.drawLine(Offset(w * 0.55, h * 0.52), Offset(w * 0.56, h * 0.75), legPaint);

    // Target Board (Tilted 3D cylinder / oval)
    final center = Offset(w * 0.55, h * 0.45);

    // Board depth/thickness
    final boardDepthPaint = Paint()..color = const Color(0xFF064E3B);
    for (double i = 0; i < 8; i += 1.5) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx + i * 0.7, center.dy + i * 0.4),
          width: w * 0.48,
          height: h * 0.52,
        ),
        boardDepthPaint,
      );
    }

    // Outer Ring (Dark Green)
    final outerRingPaint = Paint()..color = const Color(0xFF047857);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.48, height: h * 0.52),
      outerRingPaint,
    );

    // Middle Ring (Vibrant Green)
    final midRingPaint = Paint()..color = const Color(0xFF10B981);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.34, height: h * 0.38),
      midRingPaint,
    );

    // Inner Ring (Light Mint Green)
    final innerRingPaint = Paint()..color = const Color(0xFF6EE7B7);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.22, height: h * 0.25),
      innerRingPaint,
    );

    // Bullseye Center (Gold / Yellow)
    final bullseyePaint = Paint()..color = const Color(0xFFFDE047);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: w * 0.11, height: h * 0.12),
      bullseyePaint,
    );

    // Arrows stuck in target and flying
    _drawArrow(canvas, start: Offset(w * 0.25, h * 0.62), end: Offset(w * 0.50, h * 0.47));
    _drawArrow(canvas, start: Offset(w * 0.32, h * 0.28), end: Offset(w * 0.53, h * 0.43));
    _drawArrow(canvas, start: Offset(w * 0.40, h * 0.85), end: Offset(w * 0.58, h * 0.75));
    _drawArrow(canvas, start: Offset(w * 0.78, h * 0.65), end: Offset(w * 0.68, h * 0.56));
  }

  void _drawArrow(Canvas canvas, {required Offset start, required Offset end}) {
    final shaftPaint = Paint()
      ..color = const Color(0xFFFDE68A)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, shaftPaint);

    // Arrow feather (flights) at start
    final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
    final fLen = 4.0;
    final f1 = Offset(
      start.dx - fLen * math.cos(angle - 0.6),
      start.dy - fLen * math.sin(angle - 0.6),
    );
    final f2 = Offset(
      start.dx - fLen * math.cos(angle + 0.6),
      start.dy - fLen * math.sin(angle + 0.6),
    );

    final fPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..strokeWidth = 1.5;

    canvas.drawLine(start, f1, fPaint);
    canvas.drawLine(start, f2, fPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
