import 'package:flutter_bloc/flutter_bloc.dart';

import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState(favoriteFoodIds: {})) {
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  void _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) {
    final updated = Set<String>.from(state.favoriteFoodIds);
    if (updated.contains(event.foodId)) {
      updated.remove(event.foodId);
    } else {
      updated.add(event.foodId);
    }
    emit(state.copyWith(favoriteFoodIds: updated));
  }
}
