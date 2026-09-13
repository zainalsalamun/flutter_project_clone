import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/custom_page_routes.dart';
import '../../data/models/food_item_model.dart';
import '../bloc/favorites/favorites_bloc.dart';
import '../bloc/favorites/favorites_state.dart';
import '../bloc/food/food_promo_bloc.dart';
import '../bloc/food/food_promo_state.dart';
import '../widgets/animated_food_card.dart';
import 'food_detail_screen.dart';

class FavoritesTabScreen extends StatelessWidget {
  const FavoritesTabScreen({super.key});

  void _openDetail(BuildContext context, FoodItem food) {
    Navigator.of(context).push(
      fadeScaleRoute(FoodDetailScreen(food: food)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return SafeArea(
      child: BlocBuilder<FoodPromoBloc, FoodPromoState>(
        builder: (context, foodState) {
          return BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, favState) {
              final favoriteFoods = foodState.allFoods
                  .where((food) => favState.isFavorite(food.id))
                  .toList();

              if (favoriteFoods.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: const BoxDecoration(
                            color: FoodPromoTheme.softOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            color: FoodPromoTheme.orange,
                            size: 44,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          l.favoritesEmpty,
                          style: const TextStyle(
                            color: FoodPromoTheme.ink,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.favoritesEmptySubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: FoodPromoTheme.muted,
                            fontSize: 14,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.favorites,
                          style: const TextStyle(
                            color: FoodPromoTheme.ink,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${favoriteFoods.length} items',
                          style: const TextStyle(
                            color: FoodPromoTheme.muted,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
                      itemCount: favoriteFoods.length,
                      itemBuilder: (context, index) {
                        final food = favoriteFoods[index];
                        return AnimatedFoodCard(
                          food: food,
                          scale: 1.0,
                          parallax: 0.0,
                          onTap: () => _openDetail(context, food),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
