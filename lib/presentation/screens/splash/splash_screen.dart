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
import '../../../injection.dart';
import '../../../logic/logic.dart';
import '../../../config/config.dart';
import '../../../core/core.dart';

class SplashScreen extends StatelessWidget with UIMixin {
  SplashScreen({super.key});

  final AppNavigator appNavigator = sl<AppNavigator>();
  final RouteCubit routeCubit = sl<RouteCubit>();

  @override
  Widget build(BuildContext context) {
    routeCubit.getTargetRoute();

    return BlocListener<RouteCubit, RouteState>(
      bloc: routeCubit,
      listener: (context, state) {
        if (state is RouteTarget) {
          if (state.name == AppPages.signIn) {
            appNavigator.goToSignIn(context);
          } else if (state.name == AppPages.language) {
            appNavigator.goToLanguage(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.blue,
        body: Center(
          child: Hero(
            tag: "splash",
            child: LottieBuilder.asset(
              ImageAnimation.splashLoading,
              height: isSmartphone(context) ? 220 : 250,
            ),
          ),
        ),
      ),
    );
  }
}
