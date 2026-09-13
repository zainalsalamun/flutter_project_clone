import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/localization/food_promo_localization.dart';
import '../../core/theme/food_promo_theme.dart';
import '../../core/utils/custom_page_routes.dart';
import '../../data/models/food_item_model.dart';
import '../bloc/food/food_promo_bloc.dart';
import '../bloc/food/food_promo_event.dart';
import '../bloc/food/food_promo_state.dart';
import '../widgets/animated_category_bar.dart';
import '../widgets/animated_food_card.dart';
import '../widgets/animated_search_bar.dart';
import '../widgets/cart_icon_button.dart';
import '../widgets/language_toggle.dart';
import 'cart_screen.dart';
import 'food_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;
  bool _searchActive = false;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
    _searchFocus.addListener(() {
      setState(() => _searchActive = _searchFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 260), () {
      if (mounted) {
        context.read<FoodPromoBloc>().add(SearchFoodQueryChanged(value));
      }
    });
  }

  void _openDetail(FoodItem food) {
    Navigator.of(context).push(
      fadeScaleRoute(FoodDetailScreen(food: food)),
    );
  }

  void _openCart() {
    Navigator.of(context).push(
      slideFadeRoute(const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = FoodPromoCopy.of(context);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
            child: Column(
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.goodEvening,
                            style: const TextStyle(
                              color: FoodPromoTheme.ink,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.home_rounded,
                                color: FoodPromoTheme.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                l.deliverToHome,
                                style: const TextStyle(
                                  color: FoodPromoTheme.muted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CartIconButton(onTap: _openCart),
                    const SizedBox(width: 10),
                    const LanguageToggle(),
                  ],
                ),
                const SizedBox(height: 18),
                BlocBuilder<FoodPromoBloc, FoodPromoState>(
                  buildWhen:
                      (previous, current) =>
                          previous.searchQuery != current.searchQuery,
                  builder: (context, state) {
                    return AnimatedSearchBar(
                      controller: _searchController,
                      focusNode: _searchFocus,
                      active: _searchActive || state.searchQuery.isNotEmpty,
                      onChanged: _onSearchChanged,
                      hintText: l.searchFood,
                    );
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<FoodPromoBloc, FoodPromoState>(
            buildWhen:
                (previous, current) =>
                    previous.categories != current.categories ||
                    previous.selectedCategoryIndex !=
                        current.selectedCategoryIndex,
            builder: (context, state) {
              return AnimatedCategoryBar(
                categories: state.categories,
                selectedIndex: state.selectedCategoryIndex,
                onChanged: (index) {
                  context.read<FoodPromoBloc>().add(
                    SelectFoodCategory(index),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<FoodPromoBloc, FoodPromoState>(
              builder: (context, state) {
                final foods = state.filteredFoods;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 360),
                  switchInCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: ListView.builder(
                    key: ValueKey(
                      '${state.selectedCategoryIndex}-${state.searchQuery}-${foods.length}',
                    ),
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 112),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      final cardCenter = index * 202.0 + 101.0;
                      final viewportCenter =
                          _scrollOffset +
                          MediaQuery.of(context).size.height * 0.42;
                      final distance = (cardCenter - viewportCenter).abs();
                      final scale = (1 - (distance / 1900)).clamp(0.91, 1.0);
                      final parallax = ((viewportCenter - cardCenter) / 26)
                          .clamp(-12.0, 12.0);

                      return AnimatedFoodCard(
                        food: food,
                        scale: scale.toDouble(),
                        parallax: parallax.toDouble(),
                        onTap: () => _openDetail(food),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
