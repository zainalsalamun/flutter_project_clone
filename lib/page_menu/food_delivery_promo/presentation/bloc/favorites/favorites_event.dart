import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class ToggleFavoriteEvent extends FavoritesEvent {
  const ToggleFavoriteEvent(this.foodId);

  final String foodId;

  @override
  List<Object?> get props => [foodId];
}
