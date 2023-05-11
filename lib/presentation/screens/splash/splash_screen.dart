/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../injection.dart';
import '../../../logic/logic.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with UIMixin {
  final AppNavigator appNavigator = sl<AppNavigator>();
  final RouteCubit routeCubit = sl<RouteCubit>();
  final DeviceInfo deviceInfo = sl<DeviceInfo>();

  @override
  void initState() {
    super.initState();

    deviceInfo
        .getPermissionStatus(Permission.notification)
        .then((status) async {
      if (status != PermissionStatus.granted) {
        await deviceInfo.requestPermission(Permission.notification);
      }
      routeCubit.getTargetRoute(checkMinimumVersion: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RouteCubit, RouteState>(
      bloc: routeCubit,
      listener: (context, state) {
        if (state is RouteTarget) {
          if (state.name == AppPages.signIn) {
            appNavigator.goToSignIn(context);
          } else if (state.name == AppPages.language) {
            appNavigator.goToLanguage(context);
          } else if (state.name == AppPages.home) {
            appNavigator.goToHome(context);
          } else if (state.name == AppPages.signUp) {
            appNavigator.goToSignUp(context);
          } else if (state.name == AppPages.unknownDevice) {
            appNavigator.goToUnknownDevice(context);
          } else if (state.name == AppPages.updateApp) {
            appNavigator.goToUpdateApp(context);
          } else if (state.name == AppPages.initialLanguage) {
            appNavigator.goToInitialLanguage(context);
          }
        }

        if (state is RouteError) {
          /// Allow user to retry when got any error
          Alert(context).showSomethingErrorMessage(
            onActionPressed: () =>
                routeCubit.getTargetRoute(checkMinimumVersion: true),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.blue,
        body: Center(
          child: Hero(
            tag: "splash",
            child: LottieBuilder.asset(
              ImageAnimation.splashLoading,
              height: isMobile(context) ? 220 : 250,
            ),
          ),
        ),
      ),
    );
  }
}
