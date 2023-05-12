/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:go_router/go_router.dart';
import '../../core/core.dart';
import '../../data/data.dart';
import '../../observer.dart';
import '../../presentation/presentation.dart';
import 'app_pages.dart';

abstract class AppRoutes {
  static GoRouter get router => GoRouter(
        initialLocation: "/${AppPages.splash}",
        routes: [
          GoRoute(
            path: "/${AppPages.splash}",
            name: AppPages.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: "/${AppPages.callEnded}",
            name: AppPages.callEnded,
            builder: (context, state) => CallEndedScreen(
              userType: state.extra as UserType,
            ),
          ),
          GoRoute(
            path: "/${AppPages.home}",
            name: AppPages.home,
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                  path: AppPages.answerCall,
                  name: AppPages.answerCall,
                  builder: (context, state) {
                    Map<String, dynamic> extra =
                        state.extra as Map<String, dynamic>;

                    return AnswerCallScreen(
                      callID: extra["call_id"],
                      blindID: extra["blind_id"],
                      name: extra["name"],
                      urlImage: extra["url_image"],
                    );
                  }),
              GoRoute(
                path: AppPages.callHistory,
                name: AppPages.callHistory,
                builder: (context, state) => const CallHistoryScreen(),
              ),
              GoRoute(
                path: AppPages.createCall,
                name: AppPages.createCall,
                builder: (context, state) => CreateCallScreen(
                  user: state.extra as User,
                ),
              ),
              GoRoute(
                  path: AppPages.settings,
                  name: AppPages.settings,
                  builder: (context, state) => const SettingsScreen(),
                  routes: [
                    GoRoute(
                      path: AppPages.language,
                      name: AppPages.language,
                      builder: (context, state) => const LanguageScreen(),
                    ),
                  ]),
            ],
          ),
          GoRoute(
            path: "/${AppPages.initialLanguage}",
            name: AppPages.initialLanguage,
            builder: (context, state) => const LanguageScreen(),
          ),
          GoRoute(
            path: "/${AppPages.signIn}",
            name: AppPages.signIn,
            builder: (context, state) => const SignInScreen(),
          ),
          GoRoute(
            path: "/${AppPages.signUp}",
            name: AppPages.signUp,
            builder: (context, state) => const SignUpScreen(),
          ),
          GoRoute(
            path: "/${AppPages.unknownDevice}",
            name: AppPages.unknownDevice,
            builder: (context, state) => const UnknownDeviceScreen(),
          ),
          GoRoute(
            path: "/${AppPages.videoCall}",
            name: AppPages.videoCall,
            builder: (context, state) => VideoCallScreen(
              setup: state.extra as CallingSetup,
            ),
          ),
          GoRoute(
            path: "/${AppPages.updateApp}",
            name: AppPages.updateApp,
            builder: (context, state) => const UpdateAppScreen(),
          ),
        ],
        observers: [
          AppNavigatorObserver(),
        ],
      );
}
