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
import 'package:soca/config/config.dart';

class AppNavigator {
  void back<T>(BuildContext context, {T? result}) {
    if (canPop(context)) {
      Navigator.of(context).pop(result);
    }
  }

  bool canPop(BuildContext context) => Navigator.of(context).canPop();

  void goToCreateCall(BuildContext context) =>
      context.pushNamed(AppPages.createCall);

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
}
