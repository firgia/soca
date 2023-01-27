import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soca/logic/logic.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    final blocType = bloc.runtimeType;

    print("Creating Bloc type: $blocType");
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    final blocType = bloc.runtimeType;
    final changeType = change.runtimeType;

    if (blocType is LanguageBloc && changeType is LanguageState) {
      _onLanguageSelected(change);
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }

  Future<void> _onLanguageSelected(Change<dynamic> change) async {
    print("Creating Bloc type: $change");
  }
}
