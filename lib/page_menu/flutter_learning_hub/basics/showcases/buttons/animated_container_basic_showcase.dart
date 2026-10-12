import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedContainerBasicShowcase extends StatefulWidget {
  const AnimatedContainerBasicShowcase({super.key});

  @override
  State<AnimatedContainerBasicShowcase> createState() =>
      _AnimatedContainerBasicShowcaseState();
}

class _AnimatedContainerBasicShowcaseState
    extends State<AnimatedContainerBasicShowcase> {
  double _width = 120;
  double _height = 120;
  Color _color = const Color(0xFF6366F1);
  double _borderRadius = 16;
  double _opacity = 1.0;
  Curve _curve = Curves.fastOutSlowIn;

  final Random _random = Random();

  void _randomize() {
    setState(() {
      _width = _random.nextDouble() * 100 + 80;
      _height = _random.nextDouble() * 100 + 80;
      _color = Color.fromRGBO(
        _random.nextInt(200) + 40,
        _random.nextInt(200) + 40,
        _random.nextInt(200) + 40,
        1,
      );
      _borderRadius = _random.nextDouble() * 50;
      _opacity = _random.nextDouble() * 0.5 + 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Live Preview Frame
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 400),
            opacity: _opacity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: _curve,
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(_borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: _color.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Controls
        const Text(
          'Implicit Animation Controls',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),

        FilledButton.icon(
          onPressed: _randomize,
          icon: const Icon(Icons.casino_rounded, size: 18),
          label: const Text('Animate (Randomize Properties)'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            const Expanded(
              child: Text(
                'Animation Curve:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            DropdownButton<Curve>(
              value: _curve,
              isDense: true,
              items: const [
                DropdownMenuItem(
                  value: Curves.fastOutSlowIn,
                  child: Text('fastOutSlowIn', style: TextStyle(fontSize: 11)),
                ),
                DropdownMenuItem(
                  value: Curves.bounceOut,
                  child: Text('bounceOut', style: TextStyle(fontSize: 11)),
                ),
                DropdownMenuItem(
                  value: Curves.elasticOut,
                  child: Text('elasticOut', style: TextStyle(fontSize: 11)),
                ),
                DropdownMenuItem(
                  value: Curves.linear,
                  child: Text('linear', style: TextStyle(fontSize: 11)),
                ),
              ],
              onChanged: (c) {
                if (c != null) setState(() => _curve = c);
              },
            ),
          ],
        ),
      ],
    );
  }
}
