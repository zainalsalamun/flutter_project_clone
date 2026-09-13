import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';

class AnimatedCartBadge extends StatelessWidget {
  const AnimatedCartBadge({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 330),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: TweenSequence<double>([
            TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.3), weight: 70),
            TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 30),
          ]).animate(animation),
          child: child,
        );
      },
      child:
          value == 0
              ? const SizedBox.shrink(key: ValueKey('empty'))
              : Container(
                key: ValueKey(value),
                width: 19,
                height: 19,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: FoodPromoTheme.orange,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$value',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
    );
  }
}
