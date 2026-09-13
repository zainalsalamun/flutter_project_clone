import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  const FavoritesState({required this.favoriteFoodIds});

  final Set<String> favoriteFoodIds;

  bool isFavorite(String foodId) => favoriteFoodIds.contains(foodId);

  FavoritesState copyWith({Set<String>? favoriteFoodIds}) {
    return FavoritesState(
      favoriteFoodIds: favoriteFoodIds ?? this.favoriteFoodIds,
    );
  }

  @override
  List<Object?> get props => [favoriteFoodIds];
}
