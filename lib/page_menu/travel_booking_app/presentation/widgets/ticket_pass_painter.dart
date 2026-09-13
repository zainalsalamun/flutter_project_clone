import 'package:flutter/material.dart';

class TicketPassCard extends StatelessWidget {
  final Widget child;
  final double cutoutRadius;
  final double cutoutPositionFactor; // 0.0 to 1.0 (vertical position of the cutout)
  final Color backgroundColor;
  final Color shadowColor;
  final Color borderColor;

  const TicketPassCard({
    super.key,
    required this.child,
    this.cutoutRadius = 16.0,
    this.cutoutPositionFactor = 0.65,
    this.backgroundColor = Colors.white,
    this.shadowColor = const Color(0x1A141E28),
    this.borderColor = const Color(0xFFE2E8F0),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TicketPassPainter(
        cutoutRadius: cutoutRadius,
        cutoutPositionFactor: cutoutPositionFactor,
        backgroundColor: backgroundColor,
        shadowColor: shadowColor,
        borderColor: borderColor,
      ),
      child: child,
    );
  }
}

class _TicketPassPainter extends CustomPainter {
  final double cutoutRadius;
  final double cutoutPositionFactor;
  final Color backgroundColor;
  final Color shadowColor;
  final Color borderColor;

  _TicketPassPainter({
    required this.cutoutRadius,
    required this.cutoutPositionFactor,
    required this.backgroundColor,
    required this.shadowColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = 24.0;
    final double cutoutY = size.height * cutoutPositionFactor;

    final path = Path();

    // Start top-left
    path.moveTo(radius, 0);
    // Top line
    path.lineTo(size.width - radius, 0);
    // Top-right corner
    path.arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius));

    // Right edge to cutout
    path.lineTo(size.width, cutoutY - cutoutRadius);
    // Right cutout
    path.arcToPoint(
      Offset(size.width, cutoutY + cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    // Right edge to bottom
    path.lineTo(size.width, size.height - radius);
    // Bottom-right corner
    path.arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius));

    // Bottom line
    path.lineTo(radius, size.height);
    // Bottom-left corner
    path.arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius));

    // Left edge to cutout
    path.lineTo(0, cutoutY + cutoutRadius);
    // Left cutout
    path.arcToPoint(
      Offset(0, cutoutY - cutoutRadius),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    // Left edge to top
    path.lineTo(0, radius);
    // Top-left corner
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));

    path.close();

    // Shadow
    canvas.drawShadow(path, shadowColor, 12.0, true);

    // Background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, bgPaint);

    // Border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);

    // Dashed perforation line between cutouts
    final dashPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double currentX = cutoutRadius + 6;
    final endX = size.width - cutoutRadius - 6;

    while (currentX < endX) {
      canvas.drawLine(
        Offset(currentX, cutoutY),
        Offset(currentX + dashWidth, cutoutY),
        dashPaint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _TicketPassPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.cutoutPositionFactor != cutoutPositionFactor;
  }
}
