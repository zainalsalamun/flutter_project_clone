import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/models/food_item_model.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_event.dart';
import '../bloc/favorites/favorites_state.dart';
import 'animated_favorite_button.dart';
import 'food_image.dart';

class AnimatedFoodCard extends StatefulWidget {
  const AnimatedFoodCard({
    super.key,
    required this.food,
    required this.scale,
    required this.parallax,
    required this.onTap,
  });

  final FoodItem food;
  final double scale;
  final double parallax;
  final VoidCallback onTap;

  @override
  State<AnimatedFoodCard> createState() => _AnimatedFoodCardState();
}

class _AnimatedFoodCardState extends State<AnimatedFoodCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 430),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    context.read<FavoritesBloc>().add(ToggleFavoriteEvent(widget.food.id));
    _heartController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.scale * (_pressed ? 0.96 : 1.0);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        Future<void>.delayed(const Duration(milliseconds: 80), widget.onTap);
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 190),
        curve: Curves.easeOutCubic,
        child: Container(
          height: 186,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: widget.food.color.withValues(alpha: 0.11),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.food.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.food.category,
                            style: TextStyle(
                              color: widget.food.color,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const Spacer(),
                        BlocBuilder<FavoritesBloc, FavoritesState>(
                          builder: (context, favState) {
                            final isFav = favState.isFavorite(widget.food.id);
                            return AnimatedFavoriteButton(
                              selected: isFav,
                              controller: _heartController,
                              onTap: _toggleFavorite,
                            );
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      widget.food.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: FoodPromoTheme.ink,
                        fontSize: 21,
                        height: 1.02,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      widget.food.restaurant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: FoodPromoTheme.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: FoodPromoTheme.gold,
                          size: 18,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${widget.food.rating}',
                          style: const TextStyle(
                            color: FoodPromoTheme.ink,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatRupiah(widget.food.price),
                          style: const TextStyle(
                            color: FoodPromoTheme.ink,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(0, widget.parallax),
                        child: Hero(
                          tag: widget.food.heroTag,
                          child: FoodImage(
                            imageUrl: widget.food.imageUrl,
                            borderRadius: 28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: FoodPromoTheme.ink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
