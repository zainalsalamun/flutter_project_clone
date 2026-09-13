import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/currency_formatter.dart';

class AnimatedPrice extends StatelessWidget {
  const AnimatedPrice({
    super.key,
    required this.value,
    this.fontSize = 17,
    this.color = FoodPromoTheme.orange,
  });

  final int value;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(value),
      tween: Tween(begin: value.toDouble() * 0.94, end: value.toDouble()),
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return Text(
          formatRupiah(animatedValue.round()),
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
          ),
        );
      },
    );
  }
}
