import 'package:flutter/material.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import 'animated_price.dart';

class AnimatedCheckoutButton extends StatelessWidget {
  const AnimatedCheckoutButton({
    super.key,
    required this.placingOrder,
    required this.success,
    required this.total,
    required this.copy,
    required this.onTap,
  });

  final bool placingOrder;
  final bool success;
  final int total;
  final FoodPromoCopy copy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label =
        placingOrder
            ? (success ? copy.success : copy.loading)
            : copy.placeOrder;

    return GestureDetector(
      onTap: placingOrder ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: success ? FoodPromoTheme.green : FoodPromoTheme.ink,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: (success ? FoodPromoTheme.green : FoodPromoTheme.ink)
                  .withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Icon(
                success
                    ? Icons.check_circle_rounded
                    : placingOrder
                    ? Icons.hourglass_bottom_rounded
                    : Icons.receipt_long_rounded,
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
            AnimatedPrice(value: total, fontSize: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
