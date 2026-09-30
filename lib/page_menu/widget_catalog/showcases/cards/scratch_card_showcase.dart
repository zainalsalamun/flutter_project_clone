import 'package:flutter/material.dart';

class ScratchCardShowcase extends StatefulWidget {
  const ScratchCardShowcase({super.key});

  @override
  State<ScratchCardShowcase> createState() => _ScratchCardShowcaseState();
}

class _ScratchCardShowcaseState extends State<ScratchCardShowcase> {
  final List<Offset?> _scratchPoints = [];
  bool _isRevealed = false;

  void _resetCard() {
    setState(() {
      _scratchPoints.clear();
      _isRevealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _isRevealed
                ? ' Congratulations! Voucher Unlocked!'
                : 'Rub / Scratch with your finger to reveal secret promo code!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color:
                  _isRevealed ? const Color(0xFF10B981) : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 18),

          // Scratch Box
          Container(
            width: 290,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Underneath Prize Card
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.amber.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.card_giftcard_rounded,
                          color: Color(0xFFD97706),
                          size: 32,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '70% OFF DISCOUNT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB45309),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'PROMO: FLUTTER70X',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'monospace',
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scratchable Foil Overlay
                  if (!_isRevealed)
                    GestureDetector(
                      onPanUpdate: (details) {
                        final renderBox =
                            context.findRenderObject() as RenderBox?;
                        if (renderBox != null) {
                          setState(() {
                            final localPos = details.localPosition;
                            _scratchPoints.add(localPos);

                            // If scratched enough points (> 70 points), mark revealed
                            if (_scratchPoints.length > 80) {
                              _isRevealed = true;
                            }
                          });
                        }
                      },
                      onPanEnd: (_) => _scratchPoints.add(null),
                      child: CustomPaint(
                        size: const Size(290, 160),
                        painter: _ScratchPainter(points: _scratchPoints),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text(
              'Reset Voucher Foil',
              style: TextStyle(fontSize: 12),
            ),
            onPressed: _resetCard,
          ),
        ],
      ),
    );
  }
}

class _ScratchPainter extends CustomPainter {
  final List<Offset?> points;

  _ScratchPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    // Save a new layer for BlendMode.clear
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    // 1. Draw Silver / Holographic Foil Base
    final foilPaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFF94A3B8), Color(0xFFCBD5E1), Color(0xFF64748B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), foilPaint);

    // Draw pattern / prompt text on foil
    final textPainter = TextPainter(
      text: const TextSpan(
        text: ' SCRATCH HERE \nRub to Reveal Code',
        style: TextStyle(
          color: Color(0xFF334155),
          fontWeight: FontWeight.bold,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    // 2. Erase where finger scratched using BlendMode.clear
    final clearPaint =
        Paint()
          ..blendMode = BlendMode.clear
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 32;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, clearPaint);
      } else if (points[i] != null && points[i + 1] == null) {
        canvas.drawCircle(points[i]!, 16, clearPaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScratchPainter oldDelegate) {
    return true;
  }
}
