import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SlotMachineSpinnerShowcase extends StatefulWidget {
  const SlotMachineSpinnerShowcase({super.key});

  @override
  State<SlotMachineSpinnerShowcase> createState() =>
      _SlotMachineSpinnerShowcaseState();
}

class _SlotMachineSpinnerShowcaseState extends State<SlotMachineSpinnerShowcase>
    with SingleTickerProviderStateMixin {
  final List<String> _symbols = ['7⃣', '', '', '', '', '⭐', ''];

  int _reelIndex1 = 0;
  int _reelIndex2 = 0;
  int _reelIndex3 = 0;

  bool _isSpinning = false;
  String _gameMessage = 'Tarik tuas atau tekan SPIN untuk mulai!';
  Color _messageColor = Colors.white70;

  int _coinBalance = 1000;
  int _betAmount = 25; // 10, 25, 50

  late AnimationController _leverController;
  late Animation<double> _leverAnimation;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _leverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _leverAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_leverController);
  }

  @override
  void dispose() {
    _leverController.dispose();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning) return;
    if (_coinBalance < _betAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Koin tidak mencukupi untuk memasang taruhan!',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _leverController.forward(from: 0.0);

    setState(() {
      _isSpinning = true;
      _coinBalance -= _betAmount;
      _gameMessage = 'Memutar gulungan slot... ';
      _messageColor = const Color(0xFFFACC15);
    });

    // Rapid spinning ticker
    int tickCount = 0;
    Timer.periodic(const Duration(milliseconds: 70), (timer) {
      tickCount++;
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (tickCount < 18) {
          _reelIndex1 = _random.nextInt(_symbols.length);
        }
        if (tickCount < 26) {
          _reelIndex2 = _random.nextInt(_symbols.length);
        }
        if (tickCount < 34) {
          _reelIndex3 = _random.nextInt(_symbols.length);
        }
      });

      if (tickCount >= 34) {
        timer.cancel();
        _evaluateResult();
      }
    });
  }

  void _evaluateResult() {
    setState(() {
      _isSpinning = false;
      final sym1 = _symbols[_reelIndex1];
      final sym2 = _symbols[_reelIndex2];
      final sym3 = _symbols[_reelIndex3];

      if (sym1 == sym2 && sym2 == sym3) {
        // TRIPLE JACKPOT
        final win = _betAmount * 20;
        _coinBalance += win;
        _gameMessage = ' JACKPOT! Menang +$win Koin!';
        _messageColor = const Color(0xFF10B981);
      } else if (sym1 == sym2 || sym2 == sym3 || sym1 == sym3) {
        // DOUBLE MATCH
        final win = _betAmount * 3;
        _coinBalance += win;
        _gameMessage = '⭐ Keren! Cocok 2 Simbol (+ $win Koin)';
        _messageColor = const Color(0xFF38BDF8);
      } else {
        _gameMessage = 'Coba lagi! Semoga beruntung di putaran berikutnya.';
        _messageColor = Colors.white60;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------------- 1. SLOT MACHINE CABINET STAGE ----------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF881337), Color(0xFF4C0519), Color(0xFF0F172A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFACC15), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFACC15).withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Marquee Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFACC15), width: 1),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      color: Color(0xFFFACC15),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'LUCKY 777 CASINO SLOTS',
                      style: TextStyle(
                        color: Color(0xFFFACC15),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.stars_rounded,
                      color: Color(0xFFFACC15),
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Reels Window + Lever Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 3 Reels Glass Container
                  Container(
                    width: 220,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFACC15),
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Center Payline Indicator
                        Container(
                          height: 2,
                          color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                        ),

                        // 3 Reel Columns
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildReelSymbol(_symbols[_reelIndex1]),
                            const VerticalDivider(
                              color: Colors.black12,
                              width: 1,
                              thickness: 1.5,
                            ),
                            _buildReelSymbol(_symbols[_reelIndex2]),
                            const VerticalDivider(
                              color: Colors.black12,
                              width: 1,
                              thickness: 1.5,
                            ),
                            _buildReelSymbol(_symbols[_reelIndex3]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Interactive Pull Lever
                  GestureDetector(
                    onTap: _spin,
                    child: SizedBox(
                      width: 32,
                      height: 100,
                      child: AnimatedBuilder(
                        animation: _leverAnimation,
                        builder: (context, child) {
                          final pullProgress = _leverAnimation.value;
                          final knobY = 10.0 + (pullProgress * 55.0);

                          return Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // Lever Base Bracket
                              Positioned(
                                bottom: 20,
                                child: Container(
                                  width: 14,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),

                              // Metal Arm Rod
                              Positioned(
                                top: knobY + 8,
                                bottom: 30,
                                child: Container(
                                  width: 4,
                                  color: Colors.grey.shade300,
                                ),
                              ),

                              // Red Knob Ball
                              Positioned(
                                top: knobY,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    gradient: const RadialGradient(
                                      colors: [
                                        Color(0xFFEF4444),
                                        Color(0xFF991B1B),
                                      ],
                                      center: Alignment(-0.3, -0.3),
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Game Status Message
              Text(
                _gameMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _messageColor,
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),

              // Bottom Wallet & Bet Selector Row
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.monetization_on_rounded,
                          color: Color(0xFFFACC15),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_coinBalance Koin',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Bet selector chips
                    Row(
                      children:
                          [10, 25, 50].map((bet) {
                            final isSel = _betAmount == bet;
                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6),
                                onTap:
                                    _isSpinning
                                        ? null
                                        : () =>
                                            setState(() => _betAmount = bet),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSel
                                            ? const Color(0xFFFACC15)
                                            : Colors.white12,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Bet $bet',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isSel ? Colors.black : Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ---------------- 2. SPIN ACTION BUTTON ----------------
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: _isSpinning ? null : _spin,
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: Text(
              _isSpinning
                  ? 'Sedang Memutar...'
                  : 'SPIN GULUNGAN (Bet $_betAmount)',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReelSymbol(String emoji) {
    return SizedBox(
      width: 60,
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 36))),
    );
  }
}
