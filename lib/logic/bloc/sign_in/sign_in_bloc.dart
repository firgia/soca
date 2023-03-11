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
import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';
import '../../../injection.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository = sl<AuthRepository>();
  final Logger _logger = Logger("Sign In Bloc");

  SignInBloc() : super(const SignInInitial()) {
    on<SignInWithApple>(_onSignInWithApple);
    on<SignInWithGoogle>(_onSignInWithGoogle);
  }

  Future<void> _onSignInWithApple(
    SignInEvent event,
    Emitter<SignInState> emit,
  ) async {
    _logger.info("Sign in with Apple...");
    emit(const SignInLoading());

    try {
      final isSuccessfully = await _authRepository.signInWithApple();

      if (isSuccessfully) {
        _logger.fine("Successfully to sign in with Apple");
        emit(const SignInSuccessfully());
      } else {
        _logger.warning("Failed to sign in with Apple");
        emit(const SignInFailed());
      }
    } on SignInWithAppleFailure catch (e) {
      _logger.shout("Error to sign in with Apple");
      emit(SignInWithAppleError(e));
    } catch (e) {
      _logger.shout("Error to sign in with Apple");
      emit(const SignInError());
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInEvent event,
    Emitter<SignInState> emit,
  ) async {
    _logger.info("Sign in with Google...");
    emit(const SignInLoading());

    try {
      final isSuccessfully = await _authRepository.signInWithGoogle();

      if (isSuccessfully) {
        _logger.fine("Successfully to sign in with Google");
        emit(const SignInSuccessfully());
      } else {
        _logger.warning("Failed to sign in with Google");
        emit(const SignInFailed());
      }
    } on SignInWithGoogleFailure catch (e) {
      _logger.shout("Error to sign in with Google");
      emit(SignInWithGoogleError(e));
    } catch (e) {
      _logger.shout("Error to sign in with Google");
      emit(const SignInError());
    }
  }
}
