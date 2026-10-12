import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class RetroFlipClockShowcase extends StatefulWidget {
  const RetroFlipClockShowcase({super.key});

  @override
  State<RetroFlipClockShowcase> createState() => _RetroFlipClockShowcaseState();
}

class _RetroFlipClockShowcaseState extends State<RetroFlipClockShowcase> {
  bool _isCountdownMode = false;
  Timer? _timer;

  DateTime _currentTime = DateTime.now();
  int _countdownSeconds = 15 * 60; // 15 minutes
  bool _isCountdownRunning = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!_isCountdownMode) {
        setState(() {
          _currentTime = DateTime.now();
        });
      } else if (_isCountdownRunning && _countdownSeconds > 0) {
        setState(() {
          _countdownSeconds--;
        });
      }
    });
  }

  void _resetCountdown() {
    setState(() {
      _countdownSeconds = 15 * 60;
      _isCountdownRunning = true;
    });
  }

  void _toggleCountdownPause() {
    setState(() {
      _isCountdownRunning = !_isCountdownRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours =
        _isCountdownMode ? (_countdownSeconds ~/ 3600) : _currentTime.hour;
    final minutes =
        _isCountdownMode
            ? ((_countdownSeconds % 3600) ~/ 60)
            : _currentTime.minute;
    final seconds =
        _isCountdownMode ? (_countdownSeconds % 60) : _currentTime.second;

    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mode Switcher Tabs
        Row(
          children: [
            Expanded(
              child: _buildModeTab(
                title: 'Live Real-Time Clock',
                icon: Icons.access_time_rounded,
                isSelected: !_isCountdownMode,
                onTap: () => setState(() => _isCountdownMode = false),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildModeTab(
                title: 'Flash Sale Timer',
                icon: Icons.timer_rounded,
                isSelected: _isCountdownMode,
                onTap: () => setState(() => _isCountdownMode = true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Flip Clock Display Board Container
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
              // Header Title Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isCountdownMode
                          ? Icons.local_fire_department_rounded
                          : Icons.public_rounded,
                      size: 14,
                      color:
                          _isCountdownMode
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF38BDF8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isCountdownMode
                          ? 'FLASH SALE PROMO ENDS IN'
                          : 'JAKARTA LOCAL TIME (WIB)',
                      style: TextStyle(
                        color:
                            _isCountdownMode
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF38BDF8),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Flip Digit Units Row (HH : MM : SS)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FlipDigitPair(digitStr: hStr, label: 'HOURS'),
                    _buildColonSeparator(),
                    _FlipDigitPair(digitStr: mStr, label: 'MINUTES'),
                    _buildColonSeparator(),
                    _FlipDigitPair(digitStr: sStr, label: 'SECONDS'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Countdown Controller (If in countdown mode)
        if (_isCountdownMode)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _isCountdownRunning
                          ? Icons.hourglass_top_rounded
                          : Icons.pause_circle_rounded,
                      size: 18,
                      color: const Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isCountdownRunning ? 'Timer Berjalan' : 'Timer Dijeda',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isCountdownRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: const Color(0xFF6366F1),
                      ),
                      tooltip: _isCountdownRunning ? 'Jeda' : 'Lanjutkan',
                      onPressed: _toggleCountdownPause,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.restart_alt_rounded,
                        color: Colors.grey,
                      ),
                      tooltip: 'Reset 15 Menit',
                      onPressed: _resetCountdown,
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildColonSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.6),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.6),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// FLIP DIGIT PAIR WITH 3D CARD ANIMATION
// ---------------------------------------------------------------------------
class _FlipDigitPair extends StatelessWidget {
  final String digitStr;
  final String label;

  const _FlipDigitPair({required this.digitStr, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SingleFlipDigitCard(
              digit: digitStr.isNotEmpty ? digitStr[0] : '0',
            ),
            const SizedBox(width: 3),
            _SingleFlipDigitCard(
              digit: digitStr.length > 1 ? digitStr[1] : '0',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _SingleFlipDigitCard extends StatefulWidget {
  final String digit;

  const _SingleFlipDigitCard({required this.digit});

  @override
  State<_SingleFlipDigitCard> createState() => _SingleFlipDigitCardState();
}

class _SingleFlipDigitCardState extends State<_SingleFlipDigitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _flipAnim;

  String _currentDigit = '0';
  String _previousDigit = '0';

  @override
  void initState() {
    super.initState();
    _currentDigit = widget.digit;
    _previousDigit = widget.digit;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _flipAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant _SingleFlipDigitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _previousDigit = oldWidget.digit;
      _currentDigit = widget.digit;
      _animController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Static Digit Base
            Center(
              child: Text(
                _currentDigit,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
              ),
            ),

            // Center Horizontal Split Groove Line
            Positioned(
              left: 0,
              right: 0,
              top: 26,
              child: Container(height: 1.5, color: Colors.black),
            ),

            // Left & Right Hinge Pegs
            Positioned(
              left: 0,
              top: 24,
              child: Container(
                width: 3,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF64748B),
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(2),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 24,
              child: Container(
                width: 3,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF64748B),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(2),
                  ),
                ),
              ),
            ),

            // 3D Flip Overlay
            AnimatedBuilder(
              animation: _flipAnim,
              builder: (context, child) {
                if (!_animController.isAnimating) {
                  return const SizedBox.shrink();
                }

                final angle = _flipAnim.value * math.pi;
                final isTopHalf = _flipAnim.value < 0.5;

                return Transform(
                  alignment: Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(angle),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        isTopHalf ? _previousDigit : _currentDigit,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
