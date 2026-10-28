import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/aura_colors.dart';

class AuraCompanionOrb extends StatefulWidget {
  final double size;
  final bool showOrbitingIcons;

  const AuraCompanionOrb({
    super.key,
    this.size = 140,
    this.showOrbitingIcons = true,
  });

  @override
  State<AuraCompanionOrb> createState() => _AuraCompanionOrbState();
}

class _AuraCompanionOrbState extends State<AuraCompanionOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ambient Glow
              Container(
                width: widget.size * 0.82,
                height: widget.size * 0.82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AuraColors.primary.withValues(alpha: 0.28),
                      blurRadius: 36,
                      spreadRadius: 8,
                    ),
                    BoxShadow(
                      color: AuraColors.secondary.withValues(alpha: 0.22),
                      blurRadius: 28,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),

              // Animated Painter Core
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _OrbCustomPainter(
                  animationValue: _controller.value,
                ),
              ),

              // Orbiting Micro Badges if enabled
              if (widget.showOrbitingIcons) ...[
                _buildOrbitBadge(
                  angle: _controller.value * 2 * math.pi,
                  radius: widget.size * 0.44,
                  icon: Icons.menu_book_rounded,
                  color: AuraColors.journalAccent,
                  bg: AuraColors.journalBg,
                ),
                _buildOrbitBadge(
                  angle: (_controller.value * 2 * math.pi) + (2 * math.pi / 3),
                  radius: widget.size * 0.44,
                  icon: Icons.water_drop_rounded,
                  color: AuraColors.waterAccent,
                  bg: AuraColors.waterBg,
                ),
                _buildOrbitBadge(
                  angle: (_controller.value * 2 * math.pi) + (4 * math.pi / 3),
                  radius: widget.size * 0.44,
                  icon: Icons.directions_bike_rounded,
                  color: AuraColors.exerciseAccent,
                  bg: AuraColors.exerciseBg,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrbitBadge({
    required double angle,
    required double radius,
    required IconData icon,
    required Color color,
    required Color bg,
  }) {
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);

    return Transform.translate(
      offset: Offset(x, y),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 14,
          color: color,
        ),
      ),
    );
  }
}

class _OrbCustomPainter extends CustomPainter {
  final double animationValue;

  _OrbCustomPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.28;

    // Concentric Orbit Track Ring
    final trackPaint = Paint()
      ..color = AuraColors.primaryLight.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, size.width * 0.44, trackPaint);

    // Inner Glowing Core Gradient
    final coreGradient = RadialGradient(
      colors: const [
        Color(0xFFA5B4FC),
        Color(0xFF818CF8),
        Color(0xFF6366F1),
        Color(0xFF4338CA),
      ],
      stops: const [0.0, 0.45, 0.8, 1.0],
    );

    final corePaint = Paint()
      ..shader = coreGradient.createShader(
        Rect.fromCircle(center: center, radius: baseRadius),
      );

    canvas.drawCircle(center, baseRadius, corePaint);

    // Dynamic Energy Rings
    final pulseOffset = math.sin(animationValue * 2 * math.pi) * 3;
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, baseRadius - 6 + pulseOffset, ringPaint);

    // Minimalist Zen Center Ring
    final centerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 5, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant _OrbCustomPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
