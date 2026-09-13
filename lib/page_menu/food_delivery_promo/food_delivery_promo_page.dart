import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/food_promo_repository.dart';
import 'presentation/bloc/cart/cart_bloc.dart';
import 'presentation/bloc/favorites/favorites_bloc.dart';
import 'presentation/bloc/food/food_promo_bloc.dart';
import 'presentation/bloc/food/food_promo_event.dart';
import 'presentation/bloc/language/language_bloc.dart';
import 'presentation/bloc/navigation/navigation_bloc.dart';
import 'presentation/pages/food_promo_main_screen.dart';

class FoodDeliveryPromoPage extends StatelessWidget {
  const FoodDeliveryPromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = FoodPromoRepository();

    return RepositoryProvider<FoodPromoRepository>.value(
      value: repository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FoodPromoBloc>(
            create: (context) =>
                FoodPromoBloc(repository: repository)
                  ..add(const LoadFoodPromoItems()),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
          ),
          BlocProvider<FavoritesBloc>(
            create: (context) => FavoritesBloc(),
          ),
          BlocProvider<LanguageBloc>(
            create: (context) => LanguageBloc(),
          ),
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
        ],
        child: const FoodPromoMainScreen(),
      ),
    );
  }
}
