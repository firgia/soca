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

const int _maxLanguage = 3;

class SignUpInputBloc extends Bloc<SignUpInputEvent, SignUpInputState> {
  final Logger _logger = Logger("Sign Up Input Bloc");

  SignUpInputBloc() : super(const SignUpInputState()) {
    on<SignUpInputBackStep>(_onBackStep);
    on<SignUpInputDateOfBirthChanged>(_onDateOfBirthChanged);
    on<SignUpInputDeviceLanguageChanged>(_onDeviceLanguageChanged);
    on<SignUpInputGenderChanged>(_onGenderChanged);
    on<SignUpInputLanguageAdded>(_onLanguageAdded);
    on<SignUpInputLanguageRemoved>(_onLanguageRemoved);
    on<SignUpInputNameChanged>(_onNameChanged);
    on<SignUpInputNextStep>(_onNextStep);
    on<SignUpInputProfileImageChanged>(_onProfileImageChanged);
    on<SignUpInputTypeChanged>(_onTypeChanged);
  }

  void _onBackStep(
    SignUpInputBackStep event,
    Emitter<SignUpInputState> emit,
  ) {
    SignUpStep? targetStep;

    switch (state.currentStep) {
      case SignUpStep.inputPersonalInformation:
        targetStep = SignUpStep.selectLanguage;
        break;
      case SignUpStep.selectLanguage:
        targetStep = SignUpStep.selectUserType;
        break;
      default:
        break;
    }

    if (targetStep != null) {
      emit(state.copyWith(currentStep: targetStep));
      _logger.info("Back step");
    } else {
      _logger.info("Back step ignored because current step is the first step");
    }
  }

  void _onDateOfBirthChanged(
    SignUpInputDateOfBirthChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(dateOfBirth: event.dateOfBirth));
    _logger.info("Date of birth changed");
  }

  void _onDeviceLanguageChanged(
    SignUpInputDeviceLanguageChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(deviceLanguage: event.deviceLanguage));
    _logger.info("Device language changed");
  }

  void _onGenderChanged(
    SignUpInputGenderChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(gender: event.gender));
    _logger.info("Gender changed");
  }

  void _onLanguageAdded(
    SignUpInputLanguageAdded event,
    Emitter<SignUpInputState> emit,
  ) {
    List<Language>? currentLanguages = state.languages;

    if (currentLanguages != null) {
      if (currentLanguages.length >= _maxLanguage) {
        _logger
            .info("Cannot add languages, maximum languages is $_maxLanguage");
        return;
      } else {
        emit(state.copyWith(languages: [...currentLanguages, event.language]));
      }
    } else {
      emit(state.copyWith(languages: [event.language]));
    }

    _logger.info("Languages changed");
  }

  void _onLanguageRemoved(
    SignUpInputLanguageRemoved event,
    Emitter<SignUpInputState> emit,
  ) {
    List<Language>? currentLanguages = state.languages;

    if (currentLanguages?.isEmpty ?? true) {
      _logger.info("Cannot remove empty languages");
    } else {
      Language target = event.language;
      int? index = currentLanguages?.indexOf(target);

      if (index == null || index == -1) {
        _logger.info("Cannot remove language because Language is not found");
      } else {
        _logger.info("Language changed");
        emit(
          state.copyWith(languages: [...currentLanguages!]..removeAt(index)),
        );
      }
    }
  }

  void _onNameChanged(
    SignUpInputNameChanged event,
    Emitter<SignUpInputState> emit,
  ) {
    emit(state.copyWith(name: event.name));
    _logger.info("Name changed");
  }

  void _onNextStep(
    SignUpInputNextStep event,
    Emitter<SignUpInputState> emit,
  ) {
    SignUpStep? targetStep;

    switch (state.currentStep) {
      case SignUpStep.selectUserType:
        if (state.validStep == SignUpStep.selectLanguage ||
            state.validStep == SignUpStep.inputPersonalInformation) {
          targetStep = SignUpStep.selectLanguage;
        }
        break;
      case SignUpStep.selectLanguage:
        if (state.validStep == SignUpStep.inputPersonalInformation) {
          targetStep = SignUpStep.inputPersonalInformation;
        }
        break;
      default:
        break;
    }

    if (targetStep != null) {
      emit(state.copyWith(currentStep: targetStep));
      _logger.info("Next step");
    } else {
      _logger.info("Next step ignored because current step is the last step");
    }
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
}
