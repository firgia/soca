/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_input_bloc.dart';

abstract class SignUpInputEvent extends Equatable {
  const SignUpInputEvent();

  @override
  List<Object> get props => [];
}

class SignUpInputNameChanged extends SignUpInputEvent {
  const SignUpInputNameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class SignUpInputTypeChanged extends SignUpInputEvent {
  const SignUpInputTypeChanged(this.type);
  final UserType type;

  @override
  List<Object> get props => [type];
}

class SignUpInputProfileImageChanged extends SignUpInputEvent {
  const SignUpInputProfileImageChanged(this.profileImage);
  final File profileImage;

  @override
  List<Object> get props => [profileImage];
}

class SignUpInputDateOfBirthChanged extends SignUpInputEvent {
  const SignUpInputDateOfBirthChanged(this.dateOfBirth);
  final DateTime dateOfBirth;

  @override
  List<Object> get props => [dateOfBirth];
}

class SignUpInputGenderChanged extends SignUpInputEvent {
  const SignUpInputGenderChanged(this.gender);
  final Gender gender;

  @override
  List<Object> get props => [gender];
}

class SignUpInputDeviceLanguageChanged extends SignUpInputEvent {
  const SignUpInputDeviceLanguageChanged(this.deviceLanguage);
  final DeviceLanguage deviceLanguage;

  @override
  List<Object> get props => [deviceLanguage];
}

class SignUpInputLanguagesChanged extends SignUpInputEvent {
  const SignUpInputLanguagesChanged(this.languages);
  final List<Language> languages;

  @override
  List<Object> get props => [languages];
}

class SignUpInputBackStep extends SignUpInputEvent {
  const SignUpInputBackStep();
}

class SignUpInputNextStep extends SignUpInputEvent {
  const SignUpInputNextStep();
}
