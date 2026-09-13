import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';
import 'animated_price.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final int value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: strong ? FoodPromoTheme.ink : FoodPromoTheme.muted,
              fontSize: strong ? 16 : 13,
              fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
          const Spacer(),
          AnimatedPrice(value: value, fontSize: strong ? 18 : 13),
        ],
      ),
    );
  }
}
