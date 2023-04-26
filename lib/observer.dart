/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:soca/config/config.dart';
import 'package:wakelock/wakelock.dart';
import 'data/repositories/onesignal_repository.dart';
import 'injection.dart';
import 'logic/logic.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    final blocType = bloc.runtimeType;
    final changeType = change.runtimeType;

    if (blocType == LanguageBloc && changeType == Change<LanguageState>) {
      _onLanguageChanged(change as Change<LanguageState>);
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  void _onLanguageChanged(Change<LanguageState> change) {
    if (change.nextState is LanguageSelected) {
      sl<OnesignalRepository>().updateLanguage();
    }
  }
}

class AppNavigatorObserver extends NavigatorObserver {
  final AppSystemOverlay _appSystemOverlay = sl<AppSystemOverlay>();
  final Logger _logger = Logger("App Navigator Observer");

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String? routeName = route.settings.name;
    String? prevRouteName = previousRoute?.settings.name;

    _logger
        .info("didPush() {routeName:$routeName, prevRouteName:$prevRouteName}");

    if (routeName == AppPages.createCall ||
        routeName == AppPages.videoCall ||
        routeName == AppPages.answerCall) {
      Wakelock.enable();
      _appSystemOverlay.setSystemUIOverlayStyleForCall();
    } else if (routeName == AppPages.splash) {
      _appSystemOverlay.setSystemUIOverlayStyleForSplash();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String? routeName = route.settings.name;
    String? prevRouteName = previousRoute?.settings.name;

    _logger
        .info("didPop() {routeName:$routeName, prevRouteName:$prevRouteName}");

    if (routeName == AppPages.createCall ||
        routeName == AppPages.videoCall ||
        routeName == AppPages.answerCall) {
      Wakelock.disable();
      _appSystemOverlay.setSystemUIOverlayStyle();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String? routeName = route.settings.name;
    String? prevRouteName = previousRoute?.settings.name;

    _logger.info(
        "didRemove() {routeName:$routeName, prevRouteName:$prevRouteName}");

    if (routeName == AppPages.splash) {
      _appSystemOverlay.setSystemUIOverlayStyle();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    String? newRouteName = newRoute?.settings.name;
    String? oldRouteName = oldRoute?.settings.name;

    _logger.info(
        "didReplace() {newRouteName:$newRouteName, oldRouteName:$oldRouteName}");
  }
}
