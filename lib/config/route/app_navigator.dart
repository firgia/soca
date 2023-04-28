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
  }) =>
      context.pushNamed(AppPages.answerCall, extra: {
        "call_id": callID,
        "blind_id": blindID,
        "name": name,
        "url_image": urlImage,
      });

  void goToCallHistory(BuildContext context) =>
      context.pushNamed(AppPages.callHistory);

  void goToCreateCall(BuildContext context, {required User user}) =>
      context.pushNamed(AppPages.createCall, extra: user);

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

  void goToVideoCall(BuildContext context, {required CallingSetup setup}) =>
      context.pushReplacementNamed(AppPages.videoCall, extra: setup);
}
