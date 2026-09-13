import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';
import 'round_icon_button.dart';

class AnimatedQuantityStepper extends StatelessWidget {
  const AnimatedQuantityStepper({
    super.key,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          RoundIconButton(icon: Icons.remove_rounded, onTap: onMinus),
          SizedBox(
            width: 48,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: TweenSequence<double>([
                    TweenSequenceItem(
                      tween: Tween(begin: 0.8, end: 1.3),
                      weight: 60,
                    ),
                    TweenSequenceItem(
                      tween: Tween(begin: 1.3, end: 1.0),
                      weight: 40,
                    ),
                  ]).animate(animation),
                  child: child,
                );
              },
              child: Text(
                '$value',
                key: ValueKey(value),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: FoodPromoTheme.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          RoundIconButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}
