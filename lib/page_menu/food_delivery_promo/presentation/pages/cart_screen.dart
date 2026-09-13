import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/custom_page_routes.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import '../widgets/animated_cart_item.dart';
import '../widgets/cart_summary.dart';
import '../widgets/empty_cart_view.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return Scaffold(
      backgroundColor: FoodPromoTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: FoodPromoTheme.ink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l.cart,
                    style: const TextStyle(
                      color: FoodPromoTheme.ink,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state.items.isEmpty) {
                    return const EmptyCartView();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return AnimatedCartItem(
                        key: ValueKey(item.key),
                        item: item,
                      );
                    },
                  );
                },
              ),
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state.items.isEmpty) return const SizedBox.shrink();
                return CartSummary(
                  state: state,
                  copy: l,
                  onCheckout: () {
                    Navigator.of(context).push(
                      rightSlideRoute(const CheckoutScreen()),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
