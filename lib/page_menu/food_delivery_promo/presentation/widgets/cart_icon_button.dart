import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/food_promo_theme.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import 'animated_cart_badge.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.055),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(Icons.shopping_bag_rounded, color: FoodPromoTheme.ink),
            Positioned(
              top: 7,
              right: 7,
              child: BlocBuilder<CartBloc, CartState>(
                buildWhen:
                    (previous, current) =>
                        previous.totalQuantity != current.totalQuantity,
                builder: (context, state) {
                  return AnimatedCartBadge(value: state.totalQuantity);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
