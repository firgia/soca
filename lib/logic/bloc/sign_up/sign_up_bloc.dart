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

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository = sl<AuthRepository>();
  final Logger _logger = Logger("Sign Up Bloc");

  SignUpBloc() : super(const SignUpState()) {
    on<SignUpNameChanged>(_onNameChanged);
    on<SignUpTypeChanged>(_onTypeChanged);
    on<SignUpProfileImageChanged>(_onProfileImageChanged);
    on<SignUpDateOfBirthChanged>(_onDateOfBirthChanged);
    on<SignUpGenderChanged>(_onGenderChanged);
    on<SignUpDeviceLanguageChanged>(_onDeviceLanguageChanged);
    on<SignUpLanguagesChanged>(_onLanguagesChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onNameChanged(
    SignUpNameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(name: event.name));
    _logger.info("Name changed");
  }

  void _onTypeChanged(
    SignUpTypeChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(type: event.type));
    _logger.info("Type changed");
  }

  void _onProfileImageChanged(
    SignUpProfileImageChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(profileImage: event.profileImage));
    _logger.info("Profile image changed");
  }

  void _onDateOfBirthChanged(
    SignUpDateOfBirthChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(dateOfBirth: event.dateOfBirth));
    _logger.info("Date of birth changed");
  }

  void _onGenderChanged(
    SignUpGenderChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(gender: event.gender));
    _logger.info("Gender changed");
  }

  void _onDeviceLanguageChanged(
    SignUpDeviceLanguageChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(deviceLanguage: event.deviceLanguage));
    _logger.info("Device language changed");
  }

  void _onLanguagesChanged(
    SignUpLanguagesChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(languages: event.languages));
    _logger.info("Languages changed");
  }

  void _onSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.isValidToSubmit) {
      emit(const SignUpLoading());
      _logger.info("Signing Up...");

      try {
        await authRepository.signUp(
          type: state.type!,
          name: state.name!,
          profileImage: state.profileImage!,
          dateOfBirth: state.dateOfBirth!,
          gender: state.gender!,
          deviceLanguage: state.deviceLanguage,
          languages: state.languages!,
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
    } else {
      _logger
          .warning("Failed to sign up, some required input may not fill up.");
      emit(const SignUpFailed());
    }
  }
}
