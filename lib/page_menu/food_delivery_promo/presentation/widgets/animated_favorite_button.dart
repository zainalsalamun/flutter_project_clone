import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/theme/food_promo_theme.dart';

class AnimatedFavoriteButton extends StatelessWidget {
  const AnimatedFavoriteButton({
    super.key,
    required this.selected,
    required this.controller,
    required this.onTap,
  });

  final bool selected;
  final AnimationController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final burst = math.sin(controller.value * math.pi);
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ...List.generate(5, (index) {
                final angle = (index / 5) * math.pi * 2;
                return Positioned(
                  left: math.cos(angle) * burst * 17 + 15,
                  top: math.sin(angle) * burst * 17 + 15,
                  child: Opacity(
                    opacity: selected ? (1 - controller.value) : 0,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: FoodPromoTheme.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
              Transform.scale(
                scale: 1 + burst * 0.28,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 210),
                  child: Icon(
                    selected ? Icons.favorite_rounded : Icons.favorite_border,
                    key: ValueKey(selected),
                    color: selected
                        ? FoodPromoTheme.orange
                        : FoodPromoTheme.muted,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
