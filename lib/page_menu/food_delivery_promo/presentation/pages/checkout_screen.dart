import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/custom_page_routes.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import '../widgets/animated_checkout_button.dart';
import '../widgets/cart_summary_card.dart';
import '../widgets/checkout_tile.dart';
import 'success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _placingOrder = false;
  bool _success = false;

  Future<void> _placeOrder() async {
    if (_placingOrder) return;
    setState(() => _placingOrder = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _success = true);
    await Future<void>.delayed(const Duration(milliseconds: 420));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      fadeScaleRoute(const SuccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return Scaffold(
      backgroundColor: FoodPromoTheme.cream,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 134),
              children: [
                Row(
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
                      l.checkout,
                      style: const TextStyle(
                        color: FoodPromoTheme.ink,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                CheckoutTile(
                  icon: Icons.location_on_rounded,
                  title: l.deliveryAddress,
                  subtitle: l.addressValue,
                ),
                CheckoutTile(
                  icon: Icons.account_balance_wallet_rounded,
                  title: l.paymentMethod,
                  subtitle: l.paymentValue,
                ),
                CheckoutTile(
                  icon: Icons.local_offer_rounded,
                  title: l.promo,
                  subtitle: l.promoValue,
                ),
                const SizedBox(height: 12),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    return CartSummaryCard(state: state, copy: l);
                  },
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return AnimatedCheckoutButton(
                    placingOrder: _placingOrder,
                    success: _success,
                    total: state.total,
                    copy: l,
                    onTap: _placeOrder,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
