import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClawMachineArcadeShowcase extends StatefulWidget {
  const ClawMachineArcadeShowcase({super.key});

  @override
  State<ClawMachineArcadeShowcase> createState() =>
      _ClawMachineArcadeShowcaseState();
}

class _PrizeCapsule {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  double x; // 0.15 to 0.85
  bool isCollected;

  _PrizeCapsule({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.x,
    this.isCollected = false,
  });
}

class _ClawMachineArcadeShowcaseState extends State<ClawMachineArcadeShowcase>
    with SingleTickerProviderStateMixin {
  // Machine State
  double _clawX = 0.5; // 0.15 to 0.85
  double _clawY = 0.12; // 0.12 (top) to 0.72 (bottom)
  bool _isOperating = false;
  bool _isGrabbing = false;
  _PrizeCapsule? _grabbedPrize;

  // Prizes in the cabinet
  final List<_PrizeCapsule> _cabinetPrizes = [
    _PrizeCapsule(
      id: '1',
      name: 'Teddy Bear',
      emoji: '',
      color: const Color(0xFFF59E0B),
      x: 0.22,
    ),
    _PrizeCapsule(
      id: '2',
      name: 'Retro Gameboy',
      emoji: '',
      color: const Color(0xFF8B5CF6),
      x: 0.38,
    ),
    _PrizeCapsule(
      id: '3',
      name: 'Gold Trophy',
      emoji: '',
      color: const Color(0xFFEAB308),
      x: 0.52,
    ),
    _PrizeCapsule(
      id: '4',
      name: 'Mystery Box',
      emoji: '',
      color: const Color(0xFFEC4899),
      x: 0.68,
    ),
    _PrizeCapsule(
      id: '5',
      name: 'Diamond Ring',
      emoji: '',
      color: const Color(0xFF06B6D4),
      x: 0.80,
    ),
  ];

  final List<_PrizeCapsule> _collectedInventory = [];
  int _tokens = 3;
  String _statusMessage =
      'Gunakan joystick untuk posisikan cakar, lalu tekan TANGKAP!';

  Timer? _moveTimer;

  @override
  void dispose() {
    _moveTimer?.cancel();
    super.dispose();
  }

  void _startContinuousMove(double direction) {
    if (_isOperating) return;
    _moveTimer?.cancel();
    _moveTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (mounted) {
        setState(() {
          _clawX = (_clawX + direction * 0.02).clamp(0.15, 0.85);
        });
      }
    });
  }

  void _stopMove() {
    _moveTimer?.cancel();
  }

  void _triggerGrab() async {
    if (_isOperating || _tokens <= 0) {
      if (_tokens <= 0) {
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
                    'Token habis! Silakan isi ulang koin token.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      _isOperating = true;
      _tokens--;
      _statusMessage = 'Cakar sedang meluncur ke bawah...';
    });

    HapticFeedback.heavyImpact();

    // Step 1: Claw descends down
    while (_clawY < 0.70) {
      await Future.delayed(const Duration(milliseconds: 25));
      if (!mounted) return;
      setState(() {
        _clawY += 0.02;
      });
    }

    // Step 2: Check prize collision at bottom
    _PrizeCapsule? matchedPrize;
    for (var prize in _cabinetPrizes) {
      if (!prize.isCollected && (_clawX - prize.x).abs() < 0.08) {
        matchedPrize = prize;
        break;
      }
    }

    setState(() {
      _isGrabbing = true;
      if (matchedPrize != null) {
        _grabbedPrize = matchedPrize;
        _statusMessage = 'Dapat ${matchedPrize.name}! Menarik ke atas... ';
      } else {
        _statusMessage = 'Oops! Cakar meleset, coba lagi!';
      }
    });

    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 400));

    // Step 3: Claw ascends back up with prize
    while (_clawY > 0.14) {
      await Future.delayed(const Duration(milliseconds: 25));
      if (!mounted) return;
      setState(() {
        _clawY -= 0.02;
        if (_grabbedPrize != null) {
          // Prize follows claw upward
        }
      });
    }

    // Step 4: Move claw to prize chute (left side: x = 0.15)
    _statusMessage = 'Membawa hadiah ke lubang pengambilan...';
    while (_clawX > 0.16) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return;
      setState(() {
        _clawX -= 0.02;
      });
    }

    // Step 5: Open claw & drop prize down the chute
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() {
        _isGrabbing = false;
        if (_grabbedPrize != null) {
          _grabbedPrize!.isCollected = true;
          _collectedInventory.add(_grabbedPrize!);
          _statusMessage = ' SELAMAT! Kamu mendapatkan ${_grabbedPrize!.name}!';
          _grabbedPrize = null;
          HapticFeedback.vibrate();
        } else {
          _statusMessage = 'Cakar kosong. Coba atur posisi lebih presisi!';
        }
        _isOperating = false;
      });
    }
  }

  void _refillCabinet() {
    setState(() {
      _tokens = 3;
      _collectedInventory.clear();
      for (var p in _cabinetPrizes) {
        p.isCollected = false;
      }
      _statusMessage = 'Kabinet diisi ulang! 3 Token baru siap digunakan.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // HEADER ARCADE MARQUEE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF831843), Color(0xFF3B0764)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEC4899), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEC4899).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOKYO CRANE ARCADE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _statusMessage,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.generating_tokens_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_tokens',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // CLAW MACHINE GLASS CABINET
          Container(
            width: double.infinity,
            height: 340,
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFEC4899).withValues(alpha: 0.5),
                width: 3,
              ),
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
                  // CRANE TOP RAIL TRACK
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  // PRIZE DROP CHUTE (BOTTOM LEFT)
                  Positioned(
                    bottom: 0,
                    left: 10,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                        ),
                        border: Border.all(
                          color: const Color(0xFF38BDF8),
                          width: 2,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.south_rounded,
                            color: Color(0xFF38BDF8),
                            size: 18,
                          ),
                          Text(
                            'CHUTE',
                            style: TextStyle(
                              color: Color(0xFF38BDF8),
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // PRIZE CAPSULES AT THE BOTTOM
                  ..._cabinetPrizes.map((prize) {
                    final isGrabbed = _grabbedPrize?.id == prize.id;
                    final xPos = isGrabbed ? _clawX : prize.x;
                    final yPos = isGrabbed ? (_clawY + 0.08) : 0.78;

                    if (prize.isCollected && !isGrabbed)
                      return const SizedBox.shrink();

                    return Positioned(
                      left: (xPos * 300) - 18,
                      top: yPos * 340,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: prize.color.withValues(alpha: 0.3),
                          border: Border.all(color: prize.color, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: prize.color.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            prize.emoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  }),

                  // MECHANICAL CLAW & CABLE
                  Positioned(
                    left: (_clawX * 300) - 24,
                    top: 20,
                    child: Column(
                      children: [
                        // Cable Wire
                        Container(
                          width: 3,
                          height: (_clawY * 340) - 20,
                          color: Colors.white70,
                        ),
                        // Motor Box
                        Container(
                          width: 24,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.amber, width: 1.5),
                          ),
                        ),
                        // 3-Prong Claw Visual
                        SizedBox(
                          width: 48,
                          height: 28,
                          child: CustomPaint(
                            painter: _ClawProngsPainter(
                              isClosed: _isGrabbing,
                              accentColor: const Color(0xFFEC4899),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ARCADE PHYSICAL CONTROLLER PAD
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // JOYSTICK D-PAD (LEFT / RIGHT)
                Row(
                  children: [
                    GestureDetector(
                      onTapDown: (_) => _startContinuousMove(-1),
                      onTapUp: (_) => _stopMove(),
                      onTapCancel: _stopMove,
                      child: _buildDpadButton(Icons.arrow_back_rounded, 'KIRI'),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTapDown: (_) => _startContinuousMove(1),
                      onTapUp: (_) => _stopMove(),
                      onTapCancel: _stopMove,
                      child: _buildDpadButton(
                        Icons.arrow_forward_rounded,
                        'KANAN',
                      ),
                    ),
                  ],
                ),

                // BIG RED "GRAB" BUTTON
                ElevatedButton(
                  onPressed: _isOperating ? null : _triggerGrab,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(22),
                    elevation: 8,
                    shadowColor: const Color(0xFFEF4444).withValues(alpha: 0.6),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.pan_tool_alt_rounded, size: 24),
                      Text(
                        'TANGKAP',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // TROPHY SHELF INVENTORY
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Koleksi Hadiah (${_collectedInventory.length} / ${_cabinetPrizes.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _refillCabinet,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text(
                        'Isi Ulang',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF38BDF8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_collectedInventory.isEmpty)
                  const Text(
                    'Belum ada hadiah yang ditangkap. Tangkap boneka & trophy di atas!',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _collectedInventory.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: item.color.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.emoji,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDpadButton(IconData icon, String label) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF334155),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClawProngsPainter extends CustomPainter {
  final bool isClosed;
  final Color accentColor;

  _ClawProngsPainter({required this.isClosed, required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = accentColor
          ..strokeWidth = 3.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final centerX = size.width / 2;

    if (isClosed) {
      // Claw prongs grip tight inward
      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX - 12, size.height * 0.7),
        paint,
      );
      canvas.drawLine(
        Offset(centerX - 12, size.height * 0.7),
        Offset(centerX - 6, size.height),
        paint,
      );

      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX + 12, size.height * 0.7),
        paint,
      );
      canvas.drawLine(
        Offset(centerX + 12, size.height * 0.7),
        Offset(centerX + 6, size.height),
        paint,
      );

      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX, size.height * 0.9),
        paint,
      );
    } else {
      // Claw prongs expand wide open
      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX - 20, size.height * 0.6),
        paint,
      );
      canvas.drawLine(
        Offset(centerX - 20, size.height * 0.6),
        Offset(centerX - 12, size.height * 0.9),
        paint,
      );

      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX + 20, size.height * 0.6),
        paint,
      );
      canvas.drawLine(
        Offset(centerX + 20, size.height * 0.6),
        Offset(centerX + 12, size.height * 0.9),
        paint,
      );

      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX, size.height * 0.75),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
