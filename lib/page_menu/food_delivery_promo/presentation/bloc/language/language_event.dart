import 'package:equatable/equatable.dart';

import '../../../core/localization/food_promo_localization.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class ToggleLanguageEvent extends LanguageEvent {
  const ToggleLanguageEvent();
}

class SetLanguageEvent extends LanguageEvent {
  const SetLanguageEvent(this.language);

  final FoodLanguage language;

  @override
  List<Object?> get props => [language];
}
