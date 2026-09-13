import 'package:flutter/material.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import 'animated_price.dart';

class AnimatedAddToCartButton extends StatelessWidget {
  const AnimatedAddToCartButton({
    super.key,
    required this.loading,
    required this.added,
    required this.price,
    required this.copy,
    required this.onTap,
  });

  final bool loading;
  final bool added;
  final int price;
  final FoodPromoCopy copy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label =
        loading ? copy.loading : (added ? copy.addedToCart : copy.addToCart);

    return GestureDetector(
      onTap: loading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: added ? FoodPromoTheme.green : FoodPromoTheme.ink,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: (added ? FoodPromoTheme.green : FoodPromoTheme.ink)
                  .withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 230),
              child: Icon(
                loading
                    ? Icons.hourglass_top_rounded
                    : added
                    ? Icons.check_circle_rounded
                    : Icons.shopping_bag_rounded,
                key: ValueKey(label),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            AnimatedPrice(
              value: price,
              fontSize: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
