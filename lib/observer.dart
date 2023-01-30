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
import 'package:soca/data/repositories/onesignal_repository.dart';
import 'package:soca/injection.dart';
import 'package:soca/logic/logic.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    final blocType = bloc.runtimeType;
    final changeType = change.runtimeType;

    if (blocType == LanguageBloc && changeType == Change<LanguageState>) {
      _onLanguageSelected(change as Change<LanguageState>);
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }

  Future<void> _onLanguageSelected(Change<LanguageState> change) async {
    if (change.nextState is LanguageSelected) {
      sl<OnesignalRepository>().updateLanguage();
    }
  }
}
