import 'package:flutter/material.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: FoodPromoTheme.softOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: FoodPromoTheme.orange,
                size: 42,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l.cartEmpty,
              style: const TextStyle(
                color: FoodPromoTheme.ink,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.cartEmptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: FoodPromoTheme.muted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
