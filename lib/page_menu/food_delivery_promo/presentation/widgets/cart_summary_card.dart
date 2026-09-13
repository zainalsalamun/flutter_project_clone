import 'package:flutter/material.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../bloc/cart/cart_state.dart';
import 'animated_price.dart';
import 'summary_row.dart';

class CartSummaryCard extends StatelessWidget {
  const CartSummaryCard({
    super.key,
    required this.state,
    required this.copy,
  });

  final CartState state;
  final FoodPromoCopy copy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          ...state.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.food.name} x${item.quantity}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: FoodPromoTheme.ink,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  AnimatedPrice(value: item.total, fontSize: 13),
                ],
              ),
            ),
          ),
          const Divider(height: 22),
          SummaryRow(label: copy.total, value: state.total, strong: true),
        ],
      ),
    );
  }
}
