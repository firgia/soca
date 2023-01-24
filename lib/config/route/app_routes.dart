import 'package:go_router/go_router.dart';
import '../../presentation/presentation.dart';

class AppRoutes {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        name: "home",
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: "/sign_in",
        name: "sign_in",
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: "/sign_up",
        name: "sign_up",
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
  );
}
