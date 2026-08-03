import 'package:go_router/go_router.dart';
import '../../features/main/presentation/pages/main_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainPage(),
      ),
      // Future routes will be added here
    ],
  );
}
