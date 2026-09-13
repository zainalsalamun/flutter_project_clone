import 'package:equatable/equatable.dart';

import '../../../core/localization/food_promo_localization.dart';

class LanguageState extends Equatable {
  const LanguageState({this.language = FoodLanguage.id});

  final FoodLanguage language;

  bool get isIndonesian => language == FoodLanguage.id;

  LanguageState copyWith({FoodLanguage? language}) {
    return LanguageState(language: language ?? this.language);
  }

  @override
  List<Object?> get props => [language];
}
