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

import '../../core/core.dart';
import '../../data/data.dart';
import '../../injection.dart';
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
    if (_isCanGoToAnswerCall(context)) {
      if (_isOutdatedApp(context)) return;

      context.pushNamed(AppPages.answerCall, extra: {
        "call_id": callID,
        "blind_id": blindID,
        "name": name,
        "url_image": urlImage,
      });
    }
  }

  void goToCallEnded(BuildContext context, {required UserType userType}) {
    if (_isOutdatedApp(context)) return;

    context.pushReplacementNamed(AppPages.callEnded, extra: userType);
  }

  void goToCallHistory(BuildContext context) {
    if (_isOutdatedApp(context)) return;
    context.pushNamed(AppPages.callHistory);
  }

  void goToCreateCall(BuildContext context, {required User user}) {
    if (_isCanGoToCreateCall(context)) {
      if (_isOutdatedApp(context)) return;
      context.pushNamed(AppPages.createCall, extra: user);
    }
  }

  void goToHome(BuildContext context) {
    if (_isOutdatedApp(context)) return;
    context.pushReplacementNamed(AppPages.home);
  }

  void goToInitialLanguage(BuildContext context) {
    if (_isOutdatedApp(context)) return;
    context.pushReplacementNamed(AppPages.initialLanguage);
  }

  void goToLanguage(BuildContext context) {
    if (_isOutdatedApp(context)) return;
    context.pushNamed(AppPages.language);
  }

  void goToSplash(BuildContext context) {
    if (_isOutdatedApp(context)) return;

    // remove all previous page to make splash screen the single page on route
    // stack
    _removeAllPage(context);
    context.pushReplacementNamed(AppPages.splash);
  }

  void goToSignIn(BuildContext context) {
    if (_isOutdatedApp(context)) return;
    context.pushReplacementNamed(AppPages.signIn);
  }

  void goToSettings(BuildContext context) {
    if (_isOutdatedApp(context)) return;
    context.pushNamed(AppPages.settings);
  }

  void goToSignUp(BuildContext context) {
    if (_isOutdatedApp(context)) return;
    context.pushReplacementNamed(AppPages.signUp);
  }

  void goToUnknownDevice(BuildContext context) {
    if (_isOutdatedApp(context)) return;
    context.pushReplacementNamed(AppPages.unknownDevice);
  }

  void goToVideoCall(BuildContext context, {required CallingSetup setup}) {
    if (_isCanGoToVideoCall(context)) {
      if (_isOutdatedApp(context)) return;

      // remove all previous page to make video call the single page on route
      // stack
      _removeAllPage(context);
      context.pushReplacementNamed(AppPages.videoCall, extra: setup);
    }
  }

  void goToUpdateApp(BuildContext context) =>
      context.pushReplacementNamed(AppPages.updateApp);

  // Return true if current shown page is home
  bool _isCanGoToCreateCall(BuildContext context) {
    String? page = GoRouterState.of(context).name;

    return _isTopStack(context) && page == AppPages.home;
  }

  void _removeAllPage(BuildContext context) {
    while (context.canPop()) {
      context.pop();
    }
  }

  // Return true if page is not answer call
  bool _isCanGoToAnswerCall(BuildContext context) {
    String? page = GoRouterState.of(context).name;

    return page != AppPages.answerCall;
  }

  // Return true if current shown page is create call or answer call
  bool _isCanGoToVideoCall(BuildContext context) {
    String? page = GoRouterState.of(context).name;

    return _isTopStack(context) &&
        (page == AppPages.answerCall || page == AppPages.createCall);
  }

  bool _isTopStack(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent ?? false;

  bool _isOutdatedApp(BuildContext context) {
    bool isOutdated = sl<AppRepository>().isOutdated;
    if (isOutdated) goToUpdateApp(context);

    return isOutdated;
  }
}
