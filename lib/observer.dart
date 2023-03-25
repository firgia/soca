/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Jan 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }

  void _onLanguageChanged(Change<LanguageState> change) {
    if (change.nextState is LanguageSelected) {
      sl<OnesignalRepository>().updateLanguage();
    }
  }
}
