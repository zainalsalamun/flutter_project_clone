import 'dart:math' as math;
import 'package:flutter/material.dart';

class PulsingDotSpinnerShowcase extends StatelessWidget {
  const PulsingDotSpinnerShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              children: [
                Text(
                  'Bouncing Dot Wave',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 16),
                PulsingDotWave(color: Color(0xFF6366F1), size: 14, dotCount: 4),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Text(
                  'Pulsing Radar Ring',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                PulsingRadarRing(color: Color(0xFF10B981), size: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PulsingDotWave extends StatefulWidget {
  final Color color;
  final double size;
  final int dotCount;

  const PulsingDotWave({
    super.key,
    required this.color,
    this.size = 12,
    this.dotCount = 3,
  });

  @override
  State<PulsingDotWave> createState() => _PulsingDotWaveState();
}

class _PulsingDotWaveState extends State<PulsingDotWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.dotCount, (index) {
            final delay = index * 0.2;
            final progress = (_controller.value - delay) % 1.0;
            final sinVal = math.sin(progress * math.pi);
            final bounceOffset = (sinVal > 0 ? sinVal : 0.0) * 12;

            return Transform.translate(
              offset: Offset(0, -bounceOffset),
              child: Container(
                width: widget.size,
                height: widget.size,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class PulsingRadarRing extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingRadarRing({super.key, required this.color, this.size = 50});

  @override
  State<PulsingRadarRing> createState() => _PulsingRadarRingState();
}

class _PulsingRadarRingState extends State<PulsingRadarRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 0.4 + (_controller.value * 0.6);
          final opacity = (1.0 - _controller.value).clamp(0.0, 1.0);

          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: scale * 1.5,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withValues(alpha: opacity * 0.6),
                      width: 2,
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: scale,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: opacity * 0.3),
                  ),
                ),
              ),
              Container(
                width: widget.size * 0.3,
                height: widget.size * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
