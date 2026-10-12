import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiBurstButtonShowcase extends StatefulWidget {
  const ConfettiBurstButtonShowcase({super.key});

  @override
  State<ConfettiBurstButtonShowcase> createState() =>
      _ConfettiBurstButtonShowcaseState();
}

class _ConfettiBurstButtonShowcaseState
    extends State<ConfettiBurstButtonShowcase> {
  int _celebrationCount = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Celebrations Triggered: $_celebrationCount ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Click the reward button below to trigger 360° confetti particles!',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 32),
          ConfettiBurstButton(
            text: 'Claim 5,000 XP Reward ',
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
            ),
            onBurst: () {
              setState(() => _celebrationCount++);
            },
          ),
          const SizedBox(height: 24),
          ConfettiBurstButton(
            text: 'Complete Challenge ⭐',
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFFEC4899)],
            ),
            onBurst: () {
              setState(() => _celebrationCount++);
            },
          ),
        ],
      ),
    );
  }
}

class ConfettiBurstButton extends StatefulWidget {
  final String text;
  final Gradient gradient;
  final VoidCallback onBurst;

  const ConfettiBurstButton({
    super.key,
    required this.text,
    required this.gradient,
    required this.onBurst,
  });

  @override
  State<ConfettiBurstButton> createState() => _ConfettiBurstButtonState();
}

class _ConfettiBurstButtonState extends State<ConfettiBurstButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final math.Random _random = math.Random();

  final List<Color> _confettiColors = const [
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerBurst() {
    _particles.clear();
    // Generate 45 particles in all directions
    for (int i = 0; i < 45; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final speed = 80 + _random.nextDouble() * 120;
      final color = _confettiColors[_random.nextInt(_confettiColors.length)];
      final size = 4.0 + _random.nextDouble() * 6.0;

      _particles.add(
        _ConfettiParticle(
          dx: math.cos(angle) * speed,
          dy: math.sin(angle) * speed - 40, // upward bias
          color: color,
          size: size,
          rotation: _random.nextDouble() * 4 * math.pi,
        ),
      );
    }

    _controller.forward(from: 0.0);
    widget.onBurst();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Particle Layer
        if (_controller.isAnimating)
          CustomPaint(
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _controller.value,
            ),
          ),

        // Core Button
        Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _triggerBurst,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfettiParticle {
  final double dx;
  final double dy;
  final Color color;
  final double size;
  final double rotation;

  _ConfettiParticle({
    required this.dx,
    required this.dy,
    required this.color,
    required this.size,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      // Gravity acceleration
      final x = p.dx * progress;
      final y = p.dy * progress + (150 * progress * progress);
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint =
          Paint()
            ..color = p.color.withValues(alpha: opacity)
            ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotation * progress);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
