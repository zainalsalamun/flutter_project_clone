import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../../data/models/cart_item_model.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import 'animated_price.dart';
import 'animated_quantity_stepper.dart';
import 'food_image.dart';

class AnimatedCartItem extends StatelessWidget {
  const AnimatedCartItem({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Transform.scale(scale: 0.95 + value * 0.05, child: child),
          ),
        );
      },
      child: Dismissible(
        key: ValueKey('dismiss-${item.key}'),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 12),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 22),
          decoration: BoxDecoration(
            color: FoodPromoTheme.red,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
        onDismissed: (_) {
          context.read<CartBloc>().add(RemoveCartItemEvent(item.key));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 72,
                height: 72,
                child: FoodImage(
                  imageUrl: item.food.imageUrl,
                  borderRadius: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: FoodPromoTheme.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l.optionLabel(item.size)}  ${item.addons.isEmpty ? '' : '+ ${item.addons.length} ${l.addOnsLower}'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: FoodPromoTheme.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedPrice(value: item.total, fontSize: 14),
                  ],
                ),
              ),
              AnimatedQuantityStepper(
                value: item.quantity,
                onMinus:
                    () => context.read<CartBloc>().add(
                      DecreaseQuantityEvent(item.key),
                    ),
                onPlus:
                    () => context.read<CartBloc>().add(
                      IncreaseQuantityEvent(item.key),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
