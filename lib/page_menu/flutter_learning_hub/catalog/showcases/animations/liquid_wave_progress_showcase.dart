import 'dart:math' as math;
import 'package:flutter/material.dart';

class LiquidWaveProgressShowcase extends StatefulWidget {
  const LiquidWaveProgressShowcase({super.key});

  @override
  State<LiquidWaveProgressShowcase> createState() =>
      _LiquidWaveProgressShowcaseState();
}

class _LiquidWaveProgressShowcaseState extends State<LiquidWaveProgressShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  double _fillPercentage = 0.68; // 0.0 to 1.0
  int _shapeIndex = 0; // 0: Circle, 1: Capsule, 2: Rounded Rect

  final List<_BubbleParticle> _bubbles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(_updateBubbles);
    _waveController.repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _updateBubbles() {
    if (!mounted) return;

    // Periodically spawn new bubble
    if (_random.nextDouble() < 0.15 && _bubbles.length < 12) {
      _bubbles.add(
        _BubbleParticle(
          x: 20.0 + _random.nextDouble() * 120.0,
          y: 150.0,
          size: 3.0 + _random.nextDouble() * 5.0,
          speed: 1.0 + _random.nextDouble() * 2.0,
          wobbleSpeed: 2.0 + _random.nextDouble() * 3.0,
          initialX: 20.0 + _random.nextDouble() * 120.0,
          createdAt: DateTime.now(),
        ),
      );
    }

    final now = DateTime.now();
    _bubbles.removeWhere((b) {
      final age = now.difference(b.createdAt).inMilliseconds / 1000.0;
      return age >= 2.5;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. LIQUID WAVE CONTAINER STAGE ----------------
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Liquid Shape Container
              Container(
                width: _shapeIndex == 1 ? 120 : 160,
                height: _shapeIndex == 1 ? 180 : 160,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  shape:
                      _shapeIndex == 0 ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius:
                      _shapeIndex == 0
                          ? null
                          : BorderRadius.circular(_shapeIndex == 1 ? 60 : 28),
                  border: Border.all(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipPath(
                  clipper: _ShapeClipper(shapeIndex: _shapeIndex),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Dual-Layer Sinusoidal Waves
                      AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, child) {
                          return CustomPaint(
                            size: Size.infinite,
                            painter: _LiquidWavePainter(
                              progress: _fillPercentage,
                              animationValue: _waveController.value,
                              bubbles: _bubbles,
                              frontColor: const Color(0xFF06B6D4),
                              backColor: const Color(0xFF3B82F6),
                            ),
                          );
                        },
                      ),

                      // Percentage Display Text
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(_fillPercentage * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'KAPASITAS',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. SLIDER & SHAPE SWITCHER CONTROLS ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              // Shape selector row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bentuk Wadah Cairan:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildShapeButton(0, 'Bola', Icons.circle_outlined),
                      _buildShapeButton(
                        1,
                        'Kapsul',
                        Icons.battery_charging_full_rounded,
                      ),
                      _buildShapeButton(2, 'Kotak', Icons.crop_square_rounded),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),

              // Level slider row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tinggi Permukaan:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${(_fillPercentage * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF06B6D4),
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF06B6D4),
                  thumbColor: const Color(0xFF06B6D4),
                  inactiveTrackColor: Colors.grey.shade200,
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _fillPercentage,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (val) => setState(() => _fillPercentage = val),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShapeButton(int index, String label, IconData icon) {
    final isSelected = _shapeIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => setState(() => _shapeIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SHAPE CLIPPER
// ---------------------------------------------------------------------------
class _ShapeClipper extends CustomClipper<Path> {
  final int shapeIndex; // 0: Circle, 1: Capsule, 2: Rounded Rect

  _ShapeClipper({required this.shapeIndex});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (shapeIndex == 0) {
      path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    } else if (shapeIndex == 1) {
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(size.width / 2),
        ),
      );
    } else {
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(26),
        ),
      );
    }
    return path;
  }

  @override
  bool shouldReclip(covariant _ShapeClipper oldClipper) =>
      oldClipper.shapeIndex != shapeIndex;
}

// ---------------------------------------------------------------------------
// DUAL LIQUID WAVE PAINTER WITH BUBBLES
// ---------------------------------------------------------------------------
class _LiquidWavePainter extends CustomPainter {
  final double progress;
  final double animationValue; // 0.0 to 1.0
  final List<_BubbleParticle> bubbles;
  final Color frontColor;
  final Color backColor;

  _LiquidWavePainter({
    required this.progress,
    required this.animationValue,
    required this.bubbles,
    required this.frontColor,
    required this.backColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final baseY = size.height * (1.0 - progress.clamp(0.0, 1.0));
    final waveAmplitude = progress <= 0.01 || progress >= 0.99 ? 0.0 : 7.0;

    // 1. Back Secondary Wave (Shifted phase)
    final backPath = Path();
    backPath.moveTo(0, size.height);
    backPath.lineTo(0, baseY);

    for (double x = 0; x <= size.width; x++) {
      final y =
          baseY +
          math.sin(
                (x / size.width * 2 * math.pi) +
                    (animationValue * 2 * math.pi) +
                    math.pi / 2,
              ) *
              waveAmplitude *
              0.8;
      backPath.lineTo(x, y);
    }

    backPath.lineTo(size.width, size.height);
    backPath.close();

    final backPaint =
        Paint()
          ..color = backColor.withValues(alpha: 0.45)
          ..style = PaintingStyle.fill;
    canvas.drawPath(backPath, backPaint);

    // 2. Front Primary Wave
    final frontPath = Path();
    frontPath.moveTo(0, size.height);
    frontPath.lineTo(0, baseY);

    for (double x = 0; x <= size.width; x++) {
      final y =
          baseY +
          math.sin(
                (x / size.width * 2 * math.pi) + (animationValue * 2 * math.pi),
              ) *
              waveAmplitude;
      frontPath.lineTo(x, y);
    }

    frontPath.lineTo(size.width, size.height);
    frontPath.close();

    final frontPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [frontColor, frontColor.withValues(alpha: 0.8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromLTWH(0, baseY, size.width, size.height - baseY),
          )
          ..style = PaintingStyle.fill;

    canvas.drawPath(frontPath, frontPaint);

    // 3. Floating Bubbles inside liquid
    final now = DateTime.now();
    for (var b in bubbles) {
      final age = now.difference(b.createdAt).inMilliseconds / 1000.0;
      final currentY = size.height - (age * 55.0 * b.speed);
      if (currentY > baseY) {
        final currentX = b.initialX + math.sin(age * b.wobbleSpeed) * 8.0;
        final bubblePaint =
            Paint()
              ..color = Colors.white.withValues(alpha: 0.35)
              ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(currentX, currentY), b.size, bubblePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LiquidWavePainter oldDelegate) => true;
}

class _BubbleParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double wobbleSpeed;
  final double initialX;
  final DateTime createdAt;

  _BubbleParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.wobbleSpeed,
    required this.initialX,
    required this.createdAt,
  });
}
