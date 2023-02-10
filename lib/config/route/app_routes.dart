/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:go_router/go_router.dart';
import 'app_pages.dart';
import '../../presentation/presentation.dart';

abstract class AppRoutes {
  static GoRouter get router => GoRouter(
        initialLocation: "/${AppPages.splash}",
        routes: [
          GoRoute(
            path: "/${AppPages.splash}",
            name: AppPages.splash,
            builder: (context, state) => SplashScreen(),
          ),
          GoRoute(
            path: "/${AppPages.home}",
            name: AppPages.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: "/${AppPages.signIn}",
            name: AppPages.signIn,
            builder: (context, state) => SignInScreen(),
          ),
          GoRoute(
            path: "/${AppPages.signUp}",
            name: AppPages.signUp,
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: "/${AppPages.language}",
            name: AppPages.language,
            builder: (context, state) => LanguageScreen(),
          ),
        ],
      );
}
