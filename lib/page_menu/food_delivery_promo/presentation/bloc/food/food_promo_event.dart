import 'package:equatable/equatable.dart';

abstract class FoodPromoEvent extends Equatable {
  const FoodPromoEvent();

  @override
  List<Object?> get props => [];
}

class LoadFoodPromoItems extends FoodPromoEvent {
  const LoadFoodPromoItems();
}

class SelectFoodCategory extends FoodPromoEvent {
  const SelectFoodCategory(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class SearchFoodQueryChanged extends FoodPromoEvent {
  const SearchFoodQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
