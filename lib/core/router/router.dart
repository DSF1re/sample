import 'package:go_router/go_router.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/feature/detail/presentation/detail_screen.dart';
import 'package:todo/feature/home/presentation/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: Routes.home, builder: (context, state) => HomeScreen()),
    GoRoute(
      path: Routes.detail,
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return DetailScreen(id: id);
      },
    ),
  ],
);
