import 'dart:math' as math;
import 'package:flutter/material.dart';

class SpinLuckyWheelShowcase extends StatefulWidget {
  const SpinLuckyWheelShowcase({super.key});

  @override
  State<SpinLuckyWheelShowcase> createState() => _SpinLuckyWheelShowcaseState();
}

class _SpinLuckyWheelShowcaseState extends State<SpinLuckyWheelShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _currentRotation = 0.0;
  bool _isSpinning = false;
  String? _lastWonPrize;

  final List<_WheelSector> _sectors = const [
    _WheelSector(
      title: 'Rp 100K',
      color: Color(0xFF6366F1),
      icon: Icons.attach_money_rounded,
    ),
    _WheelSector(
      title: 'Diskon 50%',
      color: Color(0xFFEC4899),
      icon: Icons.percent_rounded,
    ),
    _WheelSector(
      title: 'Voucher 25K',
      color: Color(0xFF10B981),
      icon: Icons.card_giftcard_rounded,
    ),
    _WheelSector(
      title: 'Zonk / Coba Lagi',
      color: Color(0xFF64748B),
      icon: Icons.sentiment_neutral_rounded,
    ),
    _WheelSector(
      title: 'Cashback 80%',
      color: Color(0xFFF59E0B),
      icon: Icons.savings_rounded,
    ),
    _WheelSector(
      title: 'iPhone 15 Pro',
      color: Color(0xFF8B5CF6),
      icon: Icons.phone_iphone_rounded,
    ),
    _WheelSector(
      title: 'Free Ongkir',
      color: Color(0xFF06B6D4),
      icon: Icons.local_shipping_rounded,
    ),
    _WheelSector(
      title: 'Bonus 500 Poin',
      color: Color(0xFFEF4444),
      icon: Icons.stars_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinWheel() {
    if (_isSpinning) return;

    final random = math.Random();
    // 5 to 8 full rotations + random angle
    final extraRotations = 5 + random.nextInt(4);
    final randomTargetAngle = random.nextDouble() * 2 * math.pi;
    final totalTargetRotation =
        _currentRotation + (extraRotations * 2 * math.pi) + randomTargetAngle;

    setState(() {
      _isSpinning = true;
    });

    _animation = Tween<double>(
      begin: _currentRotation,
      end: totalTargetRotation,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward(from: 0.0).then((_) {
      _currentRotation = totalTargetRotation % (2 * math.pi);
      _isSpinning = false;

      // Pointer is located at top (3 * pi / 2)
      final sectorAngle = (2 * math.pi) / _sectors.length;
      // Adjusted angle matching the top pointer
      final normalizedAngle =
          (2 * math.pi -
              (_currentRotation % (2 * math.pi)) +
              (3 * math.pi / 2)) %
          (2 * math.pi);
      final winningIndex =
          (normalizedAngle / sectorAngle).floor() % _sectors.length;
      final winningSector = _sectors[winningIndex];

      setState(() {
        _lastWonPrize = winningSector.title;
      });

      _showWinnerDialog(winningSector);
    });
  }

  void _showWinnerDialog(_WheelSector sector) {
    final isZonk = sector.title.contains('Zonk');
    showDialog(
      context: context,
      builder:
          (ctx) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: sector.color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isZonk
                          ? Icons.refresh_rounded
                          : Icons.emoji_events_rounded,
                      size: 48,
                      color: sector.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isZonk ? 'Belum Beruntung!' : 'Selamat! Anda Menang:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sector.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: sector.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isZonk
                        ? 'Jangan patah semangat, putar lagi roda keberuntungan Anda!'
                        : 'Hadiah reward telah ditambahkan ke kupon Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: sector.color,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      'Klaim & Lanjutkan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Wheel Visual Container Box
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
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
            children: [
              // Pointer Ticker & Wheel Stack
              SizedBox(
                width: 250,
                height: 250,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Spinning Wheel Canvas
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final rotationAngle =
                            _isSpinning ? _animation.value : _currentRotation;

                        return Transform.rotate(
                          angle: rotationAngle,
                          child: CustomPaint(
                            size: const Size(240, 240),
                            painter: _WheelPainter(sectors: _sectors),
                          ),
                        );
                      },
                    ),

                    // Outer Light Bulb Rim
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFDE047).withValues(alpha: 0.4),
                          width: 4,
                        ),
                      ),
                    ),

                    // Top Pointer Ticker Pin
                    Positioned(
                      top: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 44,
                          color: Color(0xFFFDE047),
                        ),
                      ),
                    ),

                    // Center Hub Button
                    GestureDetector(
                      onTap: _spinWheel,
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFDE047),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFDE047,
                              ).withValues(alpha: 0.35),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _isSpinning ? '...' : 'SPIN',
                            style: const TextStyle(
                              color: Color(0xFFFDE047),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Spin Action Button
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isSpinning
                            ? Colors.grey.shade700
                            : const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(
                    _isSpinning ? Icons.sync_rounded : Icons.play_arrow_rounded,
                    size: 18,
                  ),
                  label: Text(
                    _isSpinning ? 'Memutar...' : 'Putar Sekarang!',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _isSpinning ? null : _spinWheel,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Last Won Status Card
        if (_lastWonPrize != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10B981)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.military_tech_rounded,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hasil Putaran Terakhir:',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        _lastWonPrize!,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _spinWheel,
                  child: const Text(
                    'Putar Lagi',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WheelSector {
  final String title;
  final Color color;
  final IconData icon;

  const _WheelSector({
    required this.title,
    required this.color,
    required this.icon,
  });
}

class _WheelPainter extends CustomPainter {
  final List<_WheelSector> sectors;

  _WheelPainter({required this.sectors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final sweepAngle = (2 * math.pi) / sectors.length;

    for (int i = 0; i < sectors.length; i++) {
      final sector = sectors[i];
      final startAngle = i * sweepAngle;

      // 1. Draw Slice Arc
      final slicePaint =
          Paint()
            ..color = sector.color
            ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        slicePaint,
      );

      // Slice Divider Line
      final linePaint =
          Paint()
            ..color = Colors.white.withValues(alpha: 0.3)
            ..strokeWidth = 1.5;
      final lineEnd = Offset(
        center.dx + radius * math.cos(startAngle),
        center.dy + radius * math.sin(startAngle),
      );
      canvas.drawLine(center, lineEnd, linePaint);

      // 2. Draw Text on Slice
      canvas.save();
      final textAngle = startAngle + (sweepAngle / 2);
      canvas.translate(
        center.dx + (radius * 0.65) * math.cos(textAngle),
        center.dy + (radius * 0.65) * math.sin(textAngle),
      );
      canvas.rotate(textAngle + (math.pi / 2));

      final textPainter = TextPainter(
        text: TextSpan(
          text: sector.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => false;
}
