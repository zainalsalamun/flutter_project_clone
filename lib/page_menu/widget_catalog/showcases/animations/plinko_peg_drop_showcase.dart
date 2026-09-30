import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlinkoPegDropShowcase extends StatefulWidget {
  const PlinkoPegDropShowcase({super.key});

  @override
  State<PlinkoPegDropShowcase> createState() => _PlinkoPegDropShowcaseState();
}

class _PlinkoBall {
  double x; // 0.0 to 1.0 relative
  double y; // 0.0 to 1.0 relative
  double vx;
  double vy;
  final Color color;
  final int id;
  bool isFinished = false;
  List<Offset> trail = [];

  _PlinkoBall({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.id,
  });
}

class _PlinkoPegDropShowcaseState extends State<PlinkoPegDropShowcase>
    with SingleTickerProviderStateMixin {
  final List<double> _multipliers = [5.0, 2.0, 1.2, 0.4, 1.2, 2.0, 5.0];
  final List<Color> _multiplierColors = [
    const Color(0xFFEF4444),
    const Color(0xFFF97316),
    const Color(0xFFEAB308),
    const Color(0xFF64748B),
    const Color(0xFFEAB308),
    const Color(0xFFF97316),
    const Color(0xFFEF4444),
  ];

  int _coins = 500;
  int _betAmount = 20;
  int _lastPayout = 0;
  int? _activeSlotIndex;

  final List<_PlinkoBall> _activeBalls = [];
  int _ballCounter = 0;
  Timer? _gameLoopTimer;

  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _startGameLoop();
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    super.dispose();
  }

  void _startGameLoop() {
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted || _activeBalls.isEmpty) return;

      setState(() {
        for (var ball in _activeBalls) {
          if (ball.isFinished) continue;

          // Physics gravity and velocity
          ball.vy += 0.0006;
          ball.x += ball.vx;
          ball.y += ball.vy;

          // Store trail for neon glow
          ball.trail.add(Offset(ball.x, ball.y));
          if (ball.trail.length > 8) {
            ball.trail.removeAt(0);
          }

          // Peg collision simulation (7 rows of pegs)
          const numRows = 7;
          for (int row = 0; row < numRows; row++) {
            final rowY = 0.18 + (row * 0.09);
            final pegsInRow = row + 3;
            final spacing = 0.8 / (pegsInRow + 1);

            for (int col = 0; col < pegsInRow; col++) {
              final pegX = 0.1 + (col + 1) * spacing;

              final dx = ball.x - pegX;
              final dy = ball.y - rowY;
              final dist = math.sqrt(dx * dx + dy * dy);

              if (dist < 0.025) {
                // Deflection bounce with elastic restitution
                final angle = math.atan2(dy, dx);
                final speed = math.sqrt(ball.vx * ball.vx + ball.vy * ball.vy);
                final randomJitter = (_random.nextDouble() - 0.5) * 0.4;

                ball.vx = math.cos(angle + randomJitter) * speed * 0.65;
                ball.vy = math.sin(angle).abs() * speed * 0.75 + 0.002;

                // Move outside peg
                ball.x = pegX + math.cos(angle) * 0.026;
                ball.y = rowY + math.sin(angle) * 0.026;

                HapticFeedback.selectionClick();
              }
            }
          }

          // Wall bounce bounds
          if (ball.x < 0.06) {
            ball.x = 0.06;
            ball.vx = ball.vx.abs() * 0.5;
          } else if (ball.x > 0.94) {
            ball.x = 0.94;
            ball.vx = -ball.vx.abs() * 0.5;
          }

          // Landed in bottom bucket
          if (ball.y >= 0.88) {
            ball.isFinished = true;
            _onBallLanded(ball);
          }
        }

        // Cleanup finished balls
        _activeBalls.removeWhere((b) => b.isFinished);
      });
    });
  }

  void _onBallLanded(_PlinkoBall ball) {
    // Calculate which multiplier slot ball landed in
    final normalizedX = ((ball.x - 0.06) / 0.88).clamp(0.0, 0.999);
    final slotIndex = (normalizedX * _multipliers.length).floor();
    final multiplier = _multipliers[slotIndex];
    final payout = (_betAmount * multiplier).round();

    _coins += payout;
    _lastPayout = payout;
    _activeSlotIndex = slotIndex;

    HapticFeedback.mediumImpact();

    // Reset active slot highlight after 500ms
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _activeSlotIndex = null;
        });
      }
    });
  }

  void _dropBall() {
    if (_coins < _betAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Koin tidak mencukupi! Silakan reset koin.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    setState(() {
      _coins -= _betAmount;
      _ballCounter++;
      final startX = 0.48 + (_random.nextDouble() - 0.5) * 0.08;
      _activeBalls.add(
        _PlinkoBall(
          x: startX,
          y: 0.08,
          vx: (_random.nextDouble() - 0.5) * 0.003,
          vy: 0.002,
          color: Colors.primaries[_ballCounter % Colors.primaries.length],
          id: _ballCounter,
        ),
      );
    });
  }

  void _dropMultiBalls(int count) {
    for (int i = 0; i < count; i++) {
      Future.delayed(Duration(milliseconds: i * 220), () {
        if (mounted) {
          _dropBall();
        }
      });
    }
  }

  void _resetCoins() {
    setState(() {
      _coins = 500;
      _lastPayout = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER WALLET & STATS CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155).withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFEAB308).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFEAB308,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.monetization_on_rounded,
                            color: Color(0xFFEAB308),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saldo Koin',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              '$_coins Koin',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_lastPayout > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF10B981)),
                        ),
                        child: Text(
                          '+$_lastPayout Koin! ',
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      )
                    else
                      IconButton(
                        onPressed: _resetCoins,
                        tooltip: 'Isi Ulang 500 Koin',
                        icon: const Icon(
                          Icons.restart_alt_rounded,
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // BET SELECTOR CHIPS
                Row(
                  children: [
                    const Text(
                      'Taruhan:',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    ...[10, 20, 50, 100].map((bet) {
                      final isSelected = _betAmount == bet;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text('$bet'),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _betAmount = bet);
                          },
                          selectedColor: const Color(0xFFEAB308),
                          backgroundColor: const Color(0xFF1E293B),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : Colors.white70,
                            fontWeight:
                                isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // PLINKO BOARD CANVAS
          Container(
            width: double.infinity,
            height: 380,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF334155), width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Stack(
                children: [
                  // CUSTOM PAINTER FOR PEGS & ACTIVE BALLS
                  CustomPaint(
                    size: Size.infinite,
                    painter: _PlinkoBoardPainter(
                      balls: _activeBalls,
                      numPegRows: 7,
                    ),
                  ),

                  // MULTIPLIER BUCKETS AT BOTTOM
                  Positioned(
                    bottom: 6,
                    left: 10,
                    right: 10,
                    child: Row(
                      children: List.generate(_multipliers.length, (idx) {
                        final isHit = _activeSlotIndex == idx;
                        final mult = _multipliers[idx];
                        final color = _multiplierColors[idx];

                        return Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.symmetric(
                              vertical: isHit ? 10 : 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isHit ? color : color.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isHit ? Colors.white : color,
                                width: isHit ? 2 : 1,
                              ),
                              boxShadow:
                                  isHit
                                      ? [
                                        BoxShadow(
                                          color: color.withValues(alpha: 0.8),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                      : null,
                            ),
                            child: Center(
                              child: Text(
                                '${mult}x',
                                style: TextStyle(
                                  color:
                                      isHit
                                          ? Colors.white
                                          : Colors.white.withValues(alpha: 0.9),
                                  fontSize: isHit ? 13 : 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // CONTROLS / DROP BUTTONS
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _dropBall,
                  icon: const Icon(Icons.arrow_downward_rounded),
                  label: const Text(
                    'Jatuhkan 1 Bola',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAB308),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _dropMultiBalls(5),
                  icon: const Icon(Icons.flash_on_rounded, size: 18),
                  label: const Text('Auto 5x', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF38BDF8),
                    side: const BorderSide(color: Color(0xFF38BDF8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlinkoBoardPainter extends CustomPainter {
  final List<_PlinkoBall> balls;
  final int numPegRows;

  _PlinkoBoardPainter({required this.balls, required this.numPegRows});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Pegs with soft neon glow
    final pegPaint = Paint()..color = Colors.white;
    final pegGlowPaint =
        Paint()
          ..color = const Color(0xFF38BDF8).withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    for (int row = 0; row < numPegRows; row++) {
      final y = size.height * (0.18 + (row * 0.09));
      final pegsInRow = row + 3;
      final spacing = (size.width * 0.8) / (pegsInRow + 1);

      for (int col = 0; col < pegsInRow; col++) {
        final x = size.width * 0.1 + (col + 1) * spacing;
        final pegOffset = Offset(x, y);

        canvas.drawCircle(pegOffset, 5.0, pegGlowPaint);
        canvas.drawCircle(pegOffset, 3.5, pegPaint);
      }
    }

    // 2. Draw Balls & Trails
    for (final ball in balls) {
      // Trail
      if (ball.trail.isNotEmpty) {
        for (int i = 0; i < ball.trail.length; i++) {
          final tOffset = Offset(
            ball.trail[i].dx * size.width,
            ball.trail[i].dy * size.height,
          );
          final opacity = ((i + 1) / ball.trail.length) * 0.4;
          final radius = 3.0 + (i * 0.4);

          canvas.drawCircle(
            tOffset,
            radius,
            Paint()..color = ball.color.withValues(alpha: opacity),
          );
        }
      }

      // Ball Body & Specular highlight
      final ballPos = Offset(ball.x * size.width, ball.y * size.height);
      final ballPaint = Paint()..color = ball.color;
      final ballGlow =
          Paint()
            ..color = ball.color.withValues(alpha: 0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(ballPos, 10.0, ballGlow);
      canvas.drawCircle(ballPos, 7.5, ballPaint);
      canvas.drawCircle(
        Offset(ballPos.dx - 2.5, ballPos.dy - 2.5),
        2.5,
        Paint()..color = Colors.white.withValues(alpha: 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
