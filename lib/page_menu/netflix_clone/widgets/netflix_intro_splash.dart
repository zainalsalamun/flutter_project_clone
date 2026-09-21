import 'dart:math' as math;
import 'package:flutter/material.dart';

class NetflixIntroSplash extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const NetflixIntroSplash({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  State<NetflixIntroSplash> createState() => _NetflixIntroSplashState();
}

class _NetflixIntroSplashState extends State<NetflixIntroSplash>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _ribbonLeft;
  late Animation<double> _ribbonCenter;
  late Animation<double> _ribbonRight;
  late Animation<double> _lightBeams;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // Fade in
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    // Left vertical bar of N
    _ribbonLeft = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.45, curve: Curves.easeOutCubic),
      ),
    );

    // Diagonal bar of N
    _ribbonCenter = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.35, 0.70, curve: Curves.easeInOutCubic),
      ),
    );

    // Right vertical bar of N
    _ribbonRight = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // Light beam explosion / dispersion
    _lightBeams = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeInExpo),
      ),
    );

    // Dramatic zoom in at the end (entering into the screen)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 28.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.78, 1.0, curve: Curves.easeInQuart),
      ),
    );

    _mainController.forward().then((_) {
      if (mounted) {
        widget.onAnimationComplete();
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          widget.onAnimationComplete();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background Ambient Glow
            AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                final glow = _fadeAnimation.value * (1.0 - _lightBeams.value);
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.7,
                      colors: [
                        const Color(0xFFE50914).withValues(alpha: 0.25 * glow),
                        Colors.black,
                      ],
                    ),
                  ),
                );
              },
            ),

            // Animated Netflix 'N' Ribbon Canvas
            AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: (1.0 - _lightBeams.value * 0.9).clamp(0.0, 1.0),
                    child: SizedBox(
                      width: 140,
                      height: 240,
                      child: CustomPaint(
                        painter: NetflixNRibbonPainter(
                          leftProgress: _ribbonLeft.value,
                          centerProgress: _ribbonCenter.value,
                          rightProgress: _ribbonRight.value,
                          beamProgress: _lightBeams.value,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // "Ta-Dum" Audio Waveform Pulse Indicator & Skip Button
            Positioned(
              bottom: 40,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.graphic_eq_rounded,
                          color: Color(0xFFE50914), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'TA-DUM',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: widget.onAnimationComplete,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white54,
                    ),
                    child: const Text('Tap to Skip Intro',
                        style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NetflixNRibbonPainter extends CustomPainter {
  final double leftProgress;
  final double centerProgress;
  final double rightProgress;
  final double beamProgress;

  NetflixNRibbonPainter({
    required this.leftProgress,
    required this.centerProgress,
    required this.rightProgress,
    required this.beamProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final barW = w * 0.28;

    // Draw Right Vertical Bar (Deeper Dark Red)
    if (rightProgress > 0) {
      final rightHeight = h * rightProgress;
      final rightRect = Rect.fromLTWH(w - barW, h - rightHeight, barW, rightHeight);
      final rightPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB81D24), Color(0xFF831010)],
        ).createShader(rightRect);

      canvas.drawRect(rightRect, rightPaint);
    }

    // Draw Left Vertical Bar (Middle Deep Red)
    if (leftProgress > 0) {
      final leftHeight = h * leftProgress;
      final leftRect = Rect.fromLTWH(0, 0, barW, leftHeight);
      final leftPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE50914), Color(0xFFB81D24)],
        ).createShader(leftRect);

      canvas.drawRect(leftRect, leftPaint);
    }

    // Draw Center Diagonal Ribbon (Bright Vibrant Red with Shadow)
    if (centerProgress > 0) {
      final path = Path();
      path.moveTo(0, 0);
      path.lineTo(barW, 0);

      final currentX = barW + (w - barW) * centerProgress;
      final currentY = h * centerProgress;

      path.lineTo(currentX, currentY);
      path.lineTo(currentX - barW, currentY);
      path.close();

      // Shadow behind diagonal
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawPath(path, shadowPaint);

      // Gradient for diagonal
      final diagPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF2E3D),
            Color(0xFFE50914),
            Color(0xFFB20710),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h));

      canvas.drawPath(path, diagPaint);
    }

    // Light Beams dispersion streaks
    if (beamProgress > 0) {
      final random = math.Random(42);
      final beamPaint = Paint()..strokeWidth = 2.0;

      for (int i = 0; i < 40; i++) {
        final angle = (i / 40.0) * 2 * math.pi;
        final length = (h * 1.5) * beamProgress * (0.8 + random.nextDouble() * 0.4);
        final hue = (i * 9) % 360;

        beamPaint.color = HSVColor.fromAHSV(
          (1.0 - beamProgress).clamp(0.0, 1.0),
          hue.toDouble(),
          0.8,
          1.0,
        ).toColor();

        canvas.drawLine(
          Offset(w / 2, h / 2),
          Offset(
            w / 2 + length * math.cos(angle),
            h / 2 + length * math.sin(angle),
          ),
          beamPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant NetflixNRibbonPainter oldDelegate) {
    return oldDelegate.leftProgress != leftProgress ||
        oldDelegate.centerProgress != centerProgress ||
        oldDelegate.rightProgress != rightProgress ||
        oldDelegate.beamProgress != beamProgress;
  }
}
