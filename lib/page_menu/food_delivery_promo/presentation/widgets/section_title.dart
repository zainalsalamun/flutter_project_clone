import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: FoodPromoTheme.ink,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
