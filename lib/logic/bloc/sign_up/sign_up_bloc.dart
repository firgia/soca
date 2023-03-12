/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';
import '../sign_up_form/sign_up_form_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository = sl<AuthRepository>();
  final Logger _logger = Logger("Sign Up Bloc");

  SignUpBloc() : super(const SignUpState()) {
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpLoading());
    _logger.info("Signing Up...");

    try {
      await authRepository.signUp(
        type: event.type,
        name: event.name,
        profileImage: event.profileImage,
        dateOfBirth: event.dateOfBirth,
        gender: event.gender,
        deviceLanguage: event.deviceLanguage,
        languages: event.languages,
      );

      _logger.fine("Sign up successfully");
      emit(const SignUpSuccessfully());
    } on SignUpFailure catch (e) {
      _logger.shout("Error to sign up");
      emit(SignUpError(e));
    } catch (e) {
      _logger.shout("Error to sign up");
      emit(const SignUpError());
    }
  }
}
