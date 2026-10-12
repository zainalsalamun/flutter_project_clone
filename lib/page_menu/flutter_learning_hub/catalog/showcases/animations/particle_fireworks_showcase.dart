import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticleFireworksShowcase extends StatefulWidget {
  const ParticleFireworksShowcase({super.key});

  @override
  State<ParticleFireworksShowcase> createState() =>
      _ParticleFireworksShowcaseState();
}

class _ParticleFireworksShowcaseState extends State<ParticleFireworksShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _tickerController;
  final List<_Rocket> _rockets = [];
  final List<_SparkParticle> _sparks = [];
  final math.Random _random = math.Random();

  bool _isAutoPartyMode = false;
  Timer? _autoPartyTimer;

  final List<List<Color>> _colorPalettes = [
    [
      const Color(0xFFFFD700),
      const Color(0xFFFF5722),
      const Color(0xFFFF4081),
      const Color(0xFF00E5FF),
      const Color(0xFF76FF03),
    ], // Rainbow Mix
    [
      const Color(0xFF00E5FF),
      const Color(0xFF3D5AFE),
      const Color(0xFFD500F9),
      const Color(0xFF651FFF),
    ], // Cyberpunk
    [
      const Color(0xFFFFD700),
      const Color(0xFFFFAB00),
      const Color(0xFFFF6D00),
      const Color(0xFFFFEA00),
    ], // Golden Sparkle
  ];

  int _selectedPaletteIndex = 0;

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updatePhysics);
    _tickerController.repeat();

    // Initial launch for preview
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _launchRocket(150, 80);
    });
  }

  @override
  void dispose() {
    _autoPartyTimer?.cancel();
    _tickerController.dispose();
    super.dispose();
  }

  void _toggleAutoParty() {
    setState(() {
      _isAutoPartyMode = !_isAutoPartyMode;
    });

    if (_isAutoPartyMode) {
      _autoPartyTimer = Timer.periodic(const Duration(milliseconds: 650), (
        timer,
      ) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        final x = 40.0 + _random.nextDouble() * 240.0;
        final y = 40.0 + _random.nextDouble() * 110.0;
        _launchRocket(x, y);
      });
    } else {
      _autoPartyTimer?.cancel();
    }
  }

  void _launchRocket(double targetX, double targetY) {
    final startX = targetX + (_random.nextDouble() * 40 - 20);
    final palette = _colorPalettes[_selectedPaletteIndex];
    final color = palette[_random.nextInt(palette.length)];

    setState(() {
      _rockets.add(
        _Rocket(
          x: startX,
          y: 220.0,
          targetX: targetX,
          targetY: targetY,
          color: color,
          speed: 7.0 + _random.nextDouble() * 3.0,
        ),
      );
    });
  }

  void _explode(double x, double y, Color color) {
    final palette = _colorPalettes[_selectedPaletteIndex];
    const sparkCount = 45;

    for (int i = 0; i < sparkCount; i++) {
      final angle =
          (i / sparkCount) * math.pi * 2 + (_random.nextDouble() * 0.2);
      final speed = 1.5 + _random.nextDouble() * 5.0;
      final sparkColor =
          _random.nextBool() ? color : palette[_random.nextInt(palette.length)];

      _sparks.add(
        _SparkParticle(
          x: x,
          y: y,
          vx: math.cos(angle) * speed,
          vy: math.sin(angle) * speed,
          color: sparkColor,
          size: 2.5 + _random.nextDouble() * 2.5,
          maxLife: 0.8 + _random.nextDouble() * 0.6,
        ),
      );
    }
  }

  void _updatePhysics() {
    if (!mounted) return;

    // 1. Update Rockets
    for (int i = _rockets.length - 1; i >= 0; i--) {
      final r = _rockets[i];
      final dx = r.targetX - r.x;
      final dy = r.targetY - r.y;
      final dist = math.sqrt(dx * dx + dy * dy);

      if (dist < 8.0 || r.y <= r.targetY) {
        _explode(r.x, r.y, r.color);
        _rockets.removeAt(i);
      } else {
        r.x += (dx / dist) * r.speed;
        r.y += (dy / dist) * r.speed;
      }
    }

    // 2. Update Sparks
    const gravity = 0.08;
    const friction = 0.96;

    for (int i = _sparks.length - 1; i >= 0; i--) {
      final s = _sparks[i];
      s.x += s.vx;
      s.y += s.vy;
      s.vy += gravity;
      s.vx *= friction;
      s.vy *= friction;
      s.age += 0.016;

      if (s.age >= s.maxLife) {
        _sparks.removeAt(i);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. NIGHT SKY FIREWORKS STAGE ----------------
        GestureDetector(
          onTapDown: (details) {
            _launchRocket(
              details.localPosition.dx.clamp(20.0, 300.0),
              details.localPosition.dy.clamp(20.0, 150.0),
            );
          },
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF030712),
                  Color(0xFF0B1329),
                  Color(0xFF1E1B4B),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Starry background dots & hint
                  Positioned(
                    top: 14,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color:
                                      _isAutoPartyMode
                                          ? const Color(0xFFFFD700)
                                          : const Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _isAutoPartyMode
                                      ? 'Mode Pesta Aktif '
                                      : 'Sentuh langit untuk ledakkan kembang api',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${_sparks.length} Partikel',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 9.5,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Custom Paint Canvas for Rockets & Sparks
                  CustomPaint(
                    size: Size.infinite,
                    painter: _FireworksCanvasPainter(
                      rockets: _rockets,
                      sparks: _sparks,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. CONTROLS & PALETTE SELECTOR ----------------
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              // Palette choice chips
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tema Warna Kembang Api:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildPaletteChip(0, 'Rainbow', [
                            Colors.amber,
                            Colors.orange,
                            Colors.pink,
                            Colors.cyan,
                          ]),
                          const SizedBox(width: 6),
                          _buildPaletteChip(1, 'Cyberpunk', [
                            Colors.cyan,
                            Colors.purple,
                            Colors.indigo,
                          ]),
                          const SizedBox(width: 6),
                          _buildPaletteChip(2, 'Gold Spark', [
                            Colors.amber,
                            Colors.orange,
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Auto Party Mode Toggle
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isAutoPartyMode
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF6366F1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  visualDensity: VisualDensity.compact,
                  elevation: 0,
                ),
                onPressed: _toggleAutoParty,
                icon: Icon(
                  _isAutoPartyMode
                      ? Icons.pause_rounded
                      : Icons.celebration_rounded,
                  size: 15,
                ),
                label: Text(
                  _isAutoPartyMode ? 'Stop' : 'Pesta',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaletteChip(int index, String label, List<Color> sampleColors) {
    final isSelected = _selectedPaletteIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaletteIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF0F172A) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children:
                  sampleColors
                      .map(
                        (c) => Container(
                          margin: const EdgeInsets.only(right: 2),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// DATA CLASSES FOR FIREWORKS PHYSICS
// ---------------------------------------------------------------------------
class _Rocket {
  double x;
  double y;
  final double targetX;
  final double targetY;
  final Color color;
  final double speed;

  _Rocket({
    required this.x,
    required this.y,
    required this.targetX,
    required this.targetY,
    required this.color,
    required this.speed,
  });
}

class _SparkParticle {
  double x;
  double y;
  double vx;
  double vy;
  final Color color;
  final double size;
  final double maxLife;
  double age = 0.0;

  _SparkParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.maxLife,
  });
}

// ---------------------------------------------------------------------------
// CUSTOM PAINTER FOR FIREWORKS
// ---------------------------------------------------------------------------
class _FireworksCanvasPainter extends CustomPainter {
  final List<_Rocket> rockets;
  final List<_SparkParticle> sparks;

  _FireworksCanvasPainter({required this.rockets, required this.sparks});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Rocket Trails
    for (var r in rockets) {
      final rocketPaint =
          Paint()
            ..color = r.color
            ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(r.x, r.y), 3.0, rocketPaint);

      // Tail spark
      final tailPaint =
          Paint()
            ..color = r.color.withValues(alpha: 0.4)
            ..strokeWidth = 2.0;
      canvas.drawLine(Offset(r.x, r.y), Offset(r.x, r.y + 12), tailPaint);
    }

    // 2. Draw Sparks with Glow & Alpha Fade
    for (var s in sparks) {
      final lifeFraction = (s.age / s.maxLife).clamp(0.0, 1.0);
      final opacity = (1.0 - lifeFraction).clamp(0.0, 1.0);
      final currentSize = s.size * (1.0 - (lifeFraction * 0.4));

      final sparkPaint =
          Paint()
            ..color = s.color.withValues(alpha: opacity)
            ..style = PaintingStyle.fill;

      // Glow halo
      final glowPaint =
          Paint()
            ..color = s.color.withValues(alpha: opacity * 0.3)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(Offset(s.x, s.y), currentSize * 1.6, glowPaint);
      canvas.drawCircle(Offset(s.x, s.y), currentSize, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FireworksCanvasPainter oldDelegate) => true;
}
