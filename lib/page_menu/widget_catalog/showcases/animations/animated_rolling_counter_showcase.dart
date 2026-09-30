import 'package:flutter/material.dart';

class AnimatedRollingCounterShowcase extends StatefulWidget {
  const AnimatedRollingCounterShowcase({super.key});

  @override
  State<AnimatedRollingCounterShowcase> createState() =>
      _AnimatedRollingCounterShowcaseState();
}

class _AnimatedRollingCounterShowcaseState
    extends State<AnimatedRollingCounterShowcase> {
  int _balance = 12450;
  int _followers = 8920;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Balance Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL WALLET BALANCE',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '+18.4% USD',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    '\$ ',
                    style: TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AnimatedRollingCounter(
                    value: _balance,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('+\$750', style: TextStyle(fontSize: 12)),
              onPressed: () {
                setState(() => _balance += 750);
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.trending_up_rounded, size: 16),
              label: const Text('+\$2,500', style: TextStyle(fontSize: 12)),
              onPressed: () {
                setState(() => _balance += 2500);
              },
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                setState(() => _balance = 12450);
              },
              child: const Text('Reset', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Social Counter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    color: Color(0xFF6366F1),
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Active Subscribers',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  AnimatedRollingCounter(
                    value: _followers,
                    textStyle: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
                    color: const Color(0xFF6366F1),
                    onPressed: () {
                      setState(() => _followers += 125);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedRollingCounter extends StatelessWidget {
  final int value;
  final TextStyle textStyle;
  final Duration duration;

  const AnimatedRollingCounter({
    super.key,
    required this.value,
    required this.textStyle,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    final digits = value.toString().split('');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          digits.map((char) {
            final intDigit = int.tryParse(char);
            if (intDigit == null) {
              return Text(char, style: textStyle);
            }

            return _SingleDigitRoller(
              digit: intDigit,
              textStyle: textStyle,
              duration: duration,
            );
          }).toList(),
    );
  }
}

class _SingleDigitRoller extends StatefulWidget {
  final int digit;
  final TextStyle textStyle;
  final Duration duration;

  const _SingleDigitRoller({
    required this.digit,
    required this.textStyle,
    required this.duration,
  });

  @override
  State<_SingleDigitRoller> createState() => _SingleDigitRollerState();
}

class _SingleDigitRollerState extends State<_SingleDigitRoller>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousDigit = 0;

  @override
  void initState() {
    super.initState();
    _previousDigit = widget.digit;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(
      begin: widget.digit.toDouble(),
      end: widget.digit.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(covariant _SingleDigitRoller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _previousDigit = oldWidget.digit;
      _animation = Tween<double>(
        begin: _previousDigit.toDouble(),
        end: widget.digit.toDouble(),
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Measure digit height
    final fontSize = widget.textStyle.fontSize ?? 20;
    final digitHeight = fontSize * 1.3;

    return SizedBox(
      height: digitHeight,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: List.generate(10, (index) {
                final offset = (index - _animation.value) * digitHeight;

                return Transform.translate(
                  offset: Offset(0, offset),
                  child: Text('$index', style: widget.textStyle),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
