import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/food_item_model.dart';
import '../../../data/repositories/food_promo_repository.dart';
import 'food_promo_event.dart';
import 'food_promo_state.dart';

class FoodPromoBloc extends Bloc<FoodPromoEvent, FoodPromoState> {
  FoodPromoBloc({required this.repository})
      : super(
          const FoodPromoState(
            categories: [],
            selectedCategoryIndex: 0,
            searchQuery: '',
            allFoods: [],
            filteredFoods: [],
            isLoading: true,
          ),
        ) {
    on<LoadFoodPromoItems>(_onLoadItems);
    on<SelectFoodCategory>(_onSelectCategory);
    on<SearchFoodQueryChanged>(_onSearchQueryChanged);
  }

  final FoodPromoRepository repository;

  void _onLoadItems(LoadFoodPromoItems event, Emitter<FoodPromoState> emit) {
    final categories = repository.getCategories();
    final allFoods = repository.getFoodItems();
    final filtered = _filterFoods(allFoods, 0, '', categories);

    emit(
      state.copyWith(
        categories: categories,
        selectedCategoryIndex: 0,
        searchQuery: '',
        allFoods: allFoods,
        filteredFoods: filtered,
        isLoading: false,
      ),
    );
  }

  void _onSelectCategory(
    SelectFoodCategory event,
    Emitter<FoodPromoState> emit,
  ) {
    final filtered = _filterFoods(
      state.allFoods,
      event.index,
      state.searchQuery,
      state.categories,
    );

    emit(
      state.copyWith(
        selectedCategoryIndex: event.index,
        filteredFoods: filtered,
      ),
    );
  }

  void _onSearchQueryChanged(
    SearchFoodQueryChanged event,
    Emitter<FoodPromoState> emit,
  ) {
    final filtered = _filterFoods(
      state.allFoods,
      state.selectedCategoryIndex,
      event.query,
      state.categories,
    );

    emit(
      state.copyWith(
        searchQuery: event.query,
        filteredFoods: filtered,
      ),
    );
  }

  List<FoodItem> _filterFoods(
    List<FoodItem> foods,
    int categoryIndex,
    String query,
    List<String> categories,
  ) {
    final category =
        categories.isNotEmpty && categoryIndex < categories.length
            ? categories[categoryIndex]
            : 'All';

    final q = query.trim().toLowerCase();

    return foods.where((food) {
      final matchCategory = category == 'All' || food.category == category;
      final matchSearch =
          q.isEmpty ||
          food.name.toLowerCase().contains(q) ||
          food.restaurant.toLowerCase().contains(q) ||
          food.category.toLowerCase().contains(q);
      return matchCategory && matchSearch;
    }).toList();
  }
}
