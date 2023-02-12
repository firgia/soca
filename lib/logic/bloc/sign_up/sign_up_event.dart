/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpNameChanged extends SignUpEvent {
  const SignUpNameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class SignUpTypeChanged extends SignUpEvent {
  const SignUpTypeChanged(this.type);
  final UserType type;

  @override
  List<Object> get props => [type];
}

class SignUpProfileImageChanged extends SignUpEvent {
  const SignUpProfileImageChanged(this.profileImage);
  final File profileImage;

  @override
  List<Object> get props => [profileImage];
}

class SignUpDateOfBirthChanged extends SignUpEvent {
  const SignUpDateOfBirthChanged(this.dateOfBirth);
  final DateTime dateOfBirth;

  @override
  List<Object> get props => [dateOfBirth];
}

class SignUpGenderChanged extends SignUpEvent {
  const SignUpGenderChanged(this.gender);
  final Gender gender;

  @override
  List<Object> get props => [gender];
}

class SignUpDeviceLanguageChanged extends SignUpEvent {
  const SignUpDeviceLanguageChanged(this.deviceLanguage);
  final DeviceLanguage deviceLanguage;

  @override
  List<Object> get props => [deviceLanguage];
}

class SignUpLanguagesChanged extends SignUpEvent {
  const SignUpLanguagesChanged(this.languages);
  final List<Language> languages;

  @override
  List<Object> get props => [languages];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
