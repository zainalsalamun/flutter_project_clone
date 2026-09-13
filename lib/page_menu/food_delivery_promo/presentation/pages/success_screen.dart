import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/custom_page_routes.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../widgets/checkmark_painter.dart';
import 'tracking_screen.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return Scaffold(
      backgroundColor: FoodPromoTheme.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticOut,
                ),
                child: CustomPaint(
                  size: const Size(126, 126),
                  painter: CheckmarkPainter(progress: _controller),
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _controller,
                child: Column(
                  children: [
                    Text(
                      l.orderConfirmed,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: FoodPromoTheme.ink,
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l.foodPrepared,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: FoodPromoTheme.muted,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '#ORD-102938',
                      style: TextStyle(
                        color: FoodPromoTheme.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      fadeScaleRoute(const TrackingScreen()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: FoodPromoTheme.ink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.route_rounded),
                  label: Text(
                    l.trackOrder,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  context.read<CartBloc>().add(const ClearCartEvent());
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(l.backToHome),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
