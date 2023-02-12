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

part 'sign_up_input_event.dart';
part 'sign_up_input_state.dart';

class SignUpInputBloc extends Bloc<SignUpInputEvent, SignUpInputState> {
  final Logger _logger = Logger("Sign Up Input Bloc");

  SignUpInputBloc() : super(const SignUpInputState()) {
    on<SignUpInputNameChanged>(_onNameChanged);
    on<SignUpInputTypeChanged>(_onTypeChanged);
    on<SignUpInputProfileImageChanged>(_onProfileImageChanged);
    on<SignUpInputDateOfBirthChanged>(_onDateOfBirthChanged);
    on<SignUpInputGenderChanged>(_onGenderChanged);
    on<SignUpInputDeviceLanguageChanged>(_onDeviceLanguageChanged);
    on<SignUpInputLanguagesChanged>(_onLanguagesChanged);
  }

  void _onNameChanged(
    SignUpInputNameChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(name: event.name));
    _logger.info("Name changed");
  }

  void _onTypeChanged(
    SignUpInputTypeChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(type: event.type));
    _logger.info("Type changed");
  }

  void _onProfileImageChanged(
    SignUpInputProfileImageChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(profileImage: event.profileImage));
    _logger.info("Profile image changed");
  }

  void _onDateOfBirthChanged(
    SignUpInputDateOfBirthChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(dateOfBirth: event.dateOfBirth));
    _logger.info("Date of birth changed");
  }

  void _onGenderChanged(
    SignUpInputGenderChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(gender: event.gender));
    _logger.info("Gender changed");
  }

  void _onDeviceLanguageChanged(
    SignUpInputDeviceLanguageChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(deviceLanguage: event.deviceLanguage));
    _logger.info("Device language changed");
  }

  void _onLanguagesChanged(
    SignUpInputLanguagesChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(languages: event.languages));
    _logger.info("Languages changed");
  }
}
