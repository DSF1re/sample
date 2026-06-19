import 'package:go_router/go_router.dart';
import 'package:todo/core/router/routes.dart';
import 'package:todo/feature/home/presentation/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: Routes.home, builder: (context, state) => HomeScreen()),
  ],
);
