/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Jan 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/data.dart';
import '../config.dart';

class AppNavigator {
  void back<T>(BuildContext context, {T? result}) {
    if (canPop(context)) {
      Navigator.of(context).pop(result);
    }
  }

  bool canPop(BuildContext context) => Navigator.of(context).canPop();

  void goToAnswerCall(
    BuildContext context, {
    required String callID,
    required String blindID,
    required String? name,
    required String? urlImage,
  }) {
    if (isCanGoToAnswerCall(context)) {
      context.pushNamed(AppPages.answerCall, extra: {
        "call_id": callID,
        "blind_id": blindID,
        "name": name,
        "url_image": urlImage,
      });
    }
  }

  void goToCallHistory(BuildContext context) =>
      context.pushNamed(AppPages.callHistory);

  void goToCreateCall(BuildContext context, {required User user}) {
    if (isCanGoToCreateCall(context)) {
      context.pushNamed(AppPages.createCall, extra: user);
    }
  }

  void goToHome(BuildContext context) =>
      context.pushReplacementNamed(AppPages.home);

  void goToLanguage(BuildContext context) =>
      context.pushReplacementNamed(AppPages.language);

  void goToSplash(BuildContext context) =>
      context.pushReplacementNamed(AppPages.splash);

  void goToSignIn(BuildContext context) =>
      context.pushReplacementNamed(AppPages.signIn);

  void goToSignUp(BuildContext context) =>
      context.pushReplacementNamed(AppPages.signUp);

  void goToUnknownDevice(BuildContext context) =>
      context.pushReplacementNamed(AppPages.unknownDevice);

  void goToVideoCall(BuildContext context, {required CallingSetup setup}) {
    if (isCanGoToVideoCall(context)) {
      context.pushReplacementNamed(AppPages.videoCall, extra: setup);
    }
  }

  // Return true if current shown page is home
  bool isCanGoToCreateCall(BuildContext context) {
    String? page = GoRouterState.of(context).name;

    return isTopStack(context) && page == AppPages.home;
  }

  // Return true if current page is not answer call
  bool isCanGoToAnswerCall(BuildContext context) {
    String? page = GoRouterState.of(context).name;

    return page != AppPages.answerCall;
  }

  // Return true if current shown page is create call or answer call
  bool isCanGoToVideoCall(BuildContext context) {
    String? page = GoRouterState.of(context).name;

    return isTopStack(context) &&
        (page == AppPages.answerCall || page == AppPages.createCall);
  }

  bool isTopStack(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? false;
}
