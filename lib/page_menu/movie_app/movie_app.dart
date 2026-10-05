import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/movie_bloc.dart';
import 'pages/splash_page.dart';
import 'repository/movie_repository.dart';
import 'services/api_service.dart';
import 'services/local_storage_service.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocalStorageService>(
      future: _initLocalStorage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator(color: Colors.red)),
            ),
          );
        }

        final localStorageService = snapshot.data!;
        return RepositoryProvider(
          create: (context) => MovieRepository(
            apiService: ApiService(),
            localStorageService: localStorageService,
          ),
          child: BlocProvider(
            create: (context) => MovieBloc(
              movieRepository: context.read<MovieRepository>(),
            ),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Movie App',
              theme: ThemeData.dark().copyWith(
                primaryColor: Colors.red,
                scaffoldBackgroundColor: Colors.black,
              ),
              home: const SplashPage(),
            ),
          ),
        );
      },
    );
  }

  Future<LocalStorageService> _initLocalStorage() async {
    final service = LocalStorageService();
    await service.init();
    return service;
  }
}
