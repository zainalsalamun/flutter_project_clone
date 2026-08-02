import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/cart_repository.dart';
import 'data/repositories/order_repository.dart';
import 'data/repositories/restaurant_repository.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/cart/cart_bloc.dart';
import 'presentation/bloc/order/order_bloc.dart';
import 'presentation/bloc/restaurant/restaurant_bloc.dart';
import 'presentation/pages/splash_page.dart';

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantRepository = RestaurantRepository();
    final cartRepository = CartRepository();
    final orderRepository = OrderRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: restaurantRepository),
        RepositoryProvider.value(value: cartRepository),
        RepositoryProvider.value(value: orderRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => RestaurantBloc(repository: restaurantRepository)),
          BlocProvider(create: (context) => CartBloc(repository: cartRepository)),
          BlocProvider(create: (context) => OrderBloc(repository: orderRepository)),
        ],
        child: MaterialApp(
          title: 'Food Delivery App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
