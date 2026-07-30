import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/api_client.dart';
import 'data/datasources/local/cart_local_data_source.dart';
import 'data/datasources/remote/product_remote_data_source.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/product_repository.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/cart/cart_bloc.dart';
import 'presentation/bloc/product/product_bloc.dart';
import 'presentation/pages/splash_page.dart';

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final productRemoteDataSource = ProductRemoteDataSource(apiClient: apiClient);
    final productRepository = ProductRepository(remoteDataSource: productRemoteDataSource);
    
    final cartLocalDataSource = CartLocalDataSource();
    final cartRepository = CartRepository(localDataSource: cartLocalDataSource);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: productRepository),
        RepositoryProvider.value(value: cartRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc()),
          BlocProvider(create: (context) => ProductBloc(repository: productRepository)),
          BlocProvider(create: (context) => CartBloc(repository: cartRepository)),
        ],
        child: MaterialApp(
          title: 'E-Commerce App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.blueAccent,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
            scaffoldBackgroundColor: Colors.white,
          ),
          home: const SplashPage(),
        ),
      ),
    );
  }
}
