import 'package:flutter/material.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../bloc/cart/cart_state.dart';
import 'summary_row.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.state,
    required this.copy,
    required this.onCheckout,
  });

  final CartState state;
  final FoodPromoCopy copy;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SummaryRow(label: copy.subtotal, value: state.subtotal),
          SummaryRow(label: copy.delivery, value: state.deliveryFee),
          SummaryRow(label: copy.serviceFee, value: state.serviceFee),
          SummaryRow(label: copy.discount, value: -state.discount),
          const Divider(height: 22),
          SummaryRow(label: copy.total, value: state.total, strong: true),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onCheckout,
              style: FilledButton.styleFrom(
                backgroundColor: FoodPromoTheme.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                copy.checkout,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
