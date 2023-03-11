/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../data/data.dart';
import '../../../injection.dart';

part 'sign_out_state.dart';

class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit() : super(const SignOutInitial());

  final AuthRepository _authRepository = sl<AuthRepository>();
  final Logger _logger = Logger("Sign Out Cubit");

  void signOut() async {
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
