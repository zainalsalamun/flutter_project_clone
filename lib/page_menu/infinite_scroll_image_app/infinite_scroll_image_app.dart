import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/photo_bloc.dart';
import 'pages/photo_gallery_page.dart';
import 'repository/photo_repository.dart';
import 'services/photo_api_service.dart';

class InfiniteScrollImageApp extends StatelessWidget {
  const InfiniteScrollImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PhotoRepository(
        apiService: PhotoApiService(),
      ),
      child: BlocProvider(
        create: (context) => PhotoBloc(
          repository: context.read<PhotoRepository>(),
        ),
        child: Theme(
          data: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              primary: const Color(0xFF6366F1),
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          ),
          child: const PhotoGalleryPage(),
        ),
      ),
    );
  }
}
