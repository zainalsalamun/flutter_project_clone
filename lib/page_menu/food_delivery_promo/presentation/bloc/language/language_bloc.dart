import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/food_promo_localization.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState()) {
    on<ToggleLanguageEvent>(_onToggleLanguage);
    on<SetLanguageEvent>(_onSetLanguage);
  }

  void _onToggleLanguage(
    ToggleLanguageEvent event,
    Emitter<LanguageState> emit,
  ) {
    final next =
        state.language == FoodLanguage.id ? FoodLanguage.en : FoodLanguage.id;
    emit(state.copyWith(language: next));
  }

  void _onSetLanguage(SetLanguageEvent event, Emitter<LanguageState> emit) {
    emit(state.copyWith(language: event.language));
  }
}
