import 'package:equatable/equatable.dart';

import '../../../data/models/food_item_model.dart';

class FoodPromoState extends Equatable {
  const FoodPromoState({
    required this.categories,
    required this.selectedCategoryIndex,
    required this.searchQuery,
    required this.allFoods,
    required this.filteredFoods,
    this.isLoading = false,
  });

  final List<String> categories;
  final int selectedCategoryIndex;
  final String searchQuery;
  final List<FoodItem> allFoods;
  final List<FoodItem> filteredFoods;
  final bool isLoading;

  String get selectedCategory =>
      categories.isNotEmpty && selectedCategoryIndex < categories.length
          ? categories[selectedCategoryIndex]
          : 'All';

  FoodPromoState copyWith({
    List<String>? categories,
    int? selectedCategoryIndex,
    String? searchQuery,
    List<FoodItem>? allFoods,
    List<FoodItem>? filteredFoods,
    bool? isLoading,
  }) {
    return FoodPromoState(
      categories: categories ?? this.categories,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      allFoods: allFoods ?? this.allFoods,
      filteredFoods: filteredFoods ?? this.filteredFoods,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    selectedCategoryIndex,
    searchQuery,
    allFoods,
    filteredFoods,
    isLoading,
  ];
}
