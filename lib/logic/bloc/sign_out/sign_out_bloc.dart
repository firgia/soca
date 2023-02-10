/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../data/data.dart';
import '../../../injection.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final AuthRepository _authRepository = sl<AuthRepository>();
  final Logger _logger = Logger("Sign Out Bloc");

  SignOutBloc() : super(const SignOutInitial()) {
    on<SignOutExecute>(_onSignOutExecute);
  }

  Future<void> _onSignOutExecute(
    SignOutEvent event,
    Emitter<SignOutState> emit,
  ) async {
    _logger.info("Sign out...");
    emit(const SignOutLoading());

    try {
      await _authRepository.signOut();
      _logger.fine("Successfully to sign out");
      emit(const SignOutSuccessfully());
    } catch (e) {
      _logger.shout("Error to sign out");
      emit(const SignOutError());
    }
  }
}
