import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingHeartsReactionShowcase extends StatefulWidget {
  const FloatingHeartsReactionShowcase({super.key});

  @override
  State<FloatingHeartsReactionShowcase> createState() =>
      _FloatingHeartsReactionShowcaseState();
}

class _FloatingHeartsReactionShowcaseState
    extends State<FloatingHeartsReactionShowcase>
    with TickerProviderStateMixin {
  int _likeCount = 1428;
  bool _isLiked = false;

  // Double-tap central heart animation
  late AnimationController _bigHeartController;
  late Animation<double> _bigHeartScale;
  late Animation<double> _bigHeartOpacity;
  bool _showBigHeart = false;

  // Floating hearts particle stream
  final List<_FloatingHeartParticle> _particles = [];
  late AnimationController _particleController;
  final math.Random _random = math.Random();

  final List<Color> _heartColors = const [
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFFF43F5E),
    Color(0xFFD946EF),
    Color(0xFFFB7185),
    Color(0xFF8B5CF6),
  ];

  @override
  void initState() {
    super.initState();

    // Central Big Heart Setup
    _bigHeartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _bigHeartScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_bigHeartController);

    _bigHeartOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 40),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(_bigHeartController);

    // Particle Controller for floating hearts stream
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_updateParticles);
    _particleController.repeat();
  }

  @override
  void dispose() {
    _bigHeartController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _triggerDoubleTapHeart() {
    setState(() {
      _showBigHeart = true;
      if (!_isLiked) {
        _isLiked = true;
        _likeCount++;
      }
    });

    _bigHeartController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() => _showBigHeart = false);
      }
    });

    // Also spawn a small burst of floating hearts
    for (int i = 0; i < 6; i++) {
      _spawnParticle();
    }
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeCount++;
        _spawnParticle();
      } else {
        _likeCount--;
      }
    });
  }

  void _spawnParticle() {
    final startX = 240 + (_random.nextDouble() * 40 - 20); // Near heart button
    final color = _heartColors[_random.nextInt(_heartColors.length)];
    final size = 18.0 + (_random.nextDouble() * 16.0);
    final speed = 1.2 + (_random.nextDouble() * 1.5);
    final wobbleFrequency = 2.0 + (_random.nextDouble() * 3.0);
    final wobbleAmplitude = 15.0 + (_random.nextDouble() * 25.0);

    setState(() {
      _particles.add(
        _FloatingHeartParticle(
          x: startX,
          y: 220.0,
          size: size,
          color: color,
          speed: speed,
          wobbleFrequency: wobbleFrequency,
          wobbleAmplitude: wobbleAmplitude,
          initialX: startX,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  void _updateParticles() {
    if (_particles.isEmpty) return;
    final now = DateTime.now();
    setState(() {
      _particles.removeWhere((p) {
        final age = now.difference(p.createdAt).inMilliseconds / 1000.0;
        return age >= 2.0; // 2 seconds lifespan
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. SOCIAL MEDIA CARD STAGE ----------------
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card User Header
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFF59E0B), Color(0xFFEC4899)],
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF0F172A),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'flutter.creator',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Bandung, Indonesia',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_horiz_rounded, size: 20),
                      color: Colors.grey.shade600,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Interactive Media Container with Double-Tap Detection
              GestureDetector(
                onDoubleTap: _triggerDoubleTapHeart,
                child: Container(
                  height: 220,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4F46E5),
                        Color(0xFF9333EA),
                        Color(0xFFDB2777),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Visual Mockup
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_rounded,
                            size: 48,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Double Tap untuk Like [Like]',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'atau tekan tombol love berkali-kali',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),

                      // Floating Hearts Particle Stream Overlay
                      ..._particles.map((p) {
                        final now = DateTime.now();
                        final age =
                            now.difference(p.createdAt).inMilliseconds / 1000.0;
                        final t = (age / 2.0).clamp(0.0, 1.0);

                        final dy = 200.0 - (t * 220.0 * p.speed);
                        final dx =
                            p.initialX +
                            math.sin(t * p.wobbleFrequency * math.pi * 2) *
                                p.wobbleAmplitude;
                        final opacity = (1.0 - t).clamp(0.0, 1.0);
                        final scale = (0.5 + (t * 0.8)).clamp(0.0, 1.3);

                        return Positioned(
                          left: dx.clamp(0.0, 300.0),
                          top: dy.clamp(0.0, 220.0),
                          child: Opacity(
                            opacity: opacity,
                            child: Transform.scale(
                              scale: scale,
                              child: Icon(
                                Icons.favorite_rounded,
                                color: p.color,
                                size: p.size,
                              ),
                            ),
                          ),
                        );
                      }),

                      // Big Central Exploding Heart Animation
                      if (_showBigHeart)
                        AnimatedBuilder(
                          animation: _bigHeartController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _bigHeartOpacity.value,
                              child: Transform.scale(
                                scale: _bigHeartScale.value,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFEF4444,
                                        ).withValues(alpha: 0.5),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.favorite_rounded,
                                    color: Colors.white,
                                    size: 80,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // Action Buttons Bar (Like, Comment, Share)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Like button with burst emitter on tap
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        _toggleLike();
                        _spawnParticle();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder:
                              (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            _isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(_isLiked),
                            color:
                                _isLiked
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF0F172A),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    IconButton(
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 22,
                      ),
                      color: const Color(0xFF0F172A),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 4),

                    IconButton(
                      icon: const Icon(Icons.send_rounded, size: 21),
                      color: const Color(0xFF0F172A),
                      visualDensity: VisualDensity.compact,
                      onPressed: () {},
                    ),

                    const Spacer(),

                    // Multi-spawn Stream Button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFEF4444,
                        ).withValues(alpha: 0.12),
                        foregroundColor: const Color(0xFFEF4444),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () {
                        for (int i = 0; i < 8; i++) {
                          Future.delayed(Duration(milliseconds: i * 60), () {
                            if (mounted) _spawnParticle();
                          });
                        }
                      },
                      icon: const Icon(Icons.auto_awesome_rounded, size: 14),
                      label: const Text(
                        'Kirim Stream [Like]',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Likes Counter Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Text(
                      '$_likeCount suka',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('•', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 6),
                    const Text(
                      '24 komentar',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FloatingHeartParticle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;
  final double wobbleFrequency;
  final double wobbleAmplitude;
  final double initialX;
  final DateTime createdAt;

  _FloatingHeartParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.wobbleFrequency,
    required this.wobbleAmplitude,
    required this.initialX,
    required this.createdAt,
  });
}
