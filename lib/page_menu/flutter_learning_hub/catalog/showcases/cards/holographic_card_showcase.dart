import 'package:flutter/material.dart';

class HolographicCardShowcase extends StatefulWidget {
  const HolographicCardShowcase({super.key});

  @override
  State<HolographicCardShowcase> createState() =>
      _HolographicCardShowcaseState();
}

class _HolographicCardShowcaseState extends State<HolographicCardShowcase> {
  double _rotateX = 0;
  double _rotateY = 0;
  double _shimmerPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Drag finger over card to interact with 3D Holographic Shine',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 20),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _rotateY += details.delta.dx * 0.008;
                  _rotateX -= details.delta.dy * 0.008;
                  _rotateX = _rotateX.clamp(-0.35, 0.35);
                  _rotateY = _rotateY.clamp(-0.35, 0.35);
                  _shimmerPosition = (_shimmerPosition +
                          details.delta.dx * 0.005)
                      .clamp(0.0, 1.0);
                });
              },
              onPanEnd: (_) {
                setState(() {
                  _rotateX = 0;
                  _rotateY = 0;
                  _shimmerPosition = 0.5;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                transform:
                    Matrix4.identity()
                      ..setEntry(3, 2, 0.002) // perspective
                      ..rotateX(_rotateX)
                      ..rotateY(_rotateY),
                alignment: Alignment.center,
                child: Container(
                  width: 320,
                  height: 195,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0F172A),
                        Color(0xFF1E1B4B),
                        Color(0xFF312E81),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: Offset(_rotateY * 25, -_rotateX * 25 + 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        // Holographic Rainbow Foil Layer
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.35,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(
                                    -1.0 + (_shimmerPosition * 2.0),
                                    -1.0,
                                  ),
                                  end: Alignment(
                                    1.0 - (_shimmerPosition * 2.0),
                                    1.0,
                                  ),
                                  colors: const [
                                    Colors.transparent,
                                    Color(0xFF06B6D4), // Cyan
                                    Color(0xFFEC4899), // Pink
                                    Color(0xFFFBBF24), // Yellow
                                    Color(0xFF8B5CF6), // Purple
                                    Colors.transparent,
                                  ],
                                  stops: const [
                                    0.0,
                                    0.25,
                                    0.45,
                                    0.65,
                                    0.85,
                                    1.0,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Card Content
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top Row: Bank Name + Contactless
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.diamond_rounded,
                                        color: Color(0xFF38BDF8),
                                        size: 22,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'AURA PLATINUM',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.contactless_rounded,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 24,
                                  ),
                                ],
                              ),

                              // EMV Gold Chip
                              Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFDE047),
                                          Color(0xFFCA8A04),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFFFEF08A),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.developer_board_rounded,
                                      color: Color(0xFF713F12),
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),

                              // Card Number
                              const Text(
                                '5428 •••• •••• 9921',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 3,
                                ),
                              ),

                              // Bottom Info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CARD HOLDER',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'ALEXANDER WRIGHT',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'EXPIRES',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        '09/30',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Mastercard style circles
                                  SizedBox(
                                    width: 36,
                                    height: 24,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 0,
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.red
                                                .withValues(alpha: 0.85),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.amber
                                                .withValues(alpha: 0.85),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
