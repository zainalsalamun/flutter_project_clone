import 'package:flutter/material.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../widgets/order_progress_painter.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 24),
              Text(
                l.orderTracking,
                style: const TextStyle(
                  color: FoodPromoTheme.ink,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.trackingSubtitle,
                style: const TextStyle(
                  color: FoodPromoTheme.muted,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: OrderProgressPainter(
                        progress: _controller.value,
                        steps: l.trackingSteps,
                      ),
                      child: const SizedBox.expand(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
