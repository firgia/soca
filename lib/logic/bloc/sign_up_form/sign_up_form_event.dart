/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_form_bloc.dart';

abstract class SignUpFormEvent extends Equatable {
  const SignUpFormEvent();

  @override
  List<Object> get props => [];
}

class SignUpFormBackStep extends SignUpFormEvent {
  const SignUpFormBackStep();
}

class SignUpFormDateOfBirthChanged extends SignUpFormEvent {
  const SignUpFormDateOfBirthChanged(this.dateOfBirth);
  final DateTime dateOfBirth;

  @override
  List<Object> get props => [dateOfBirth];
}

class SignUpFormDeviceLanguageChanged extends SignUpFormEvent {
  const SignUpFormDeviceLanguageChanged(this.deviceLanguage);
  final DeviceLanguage deviceLanguage;

  @override
  List<Object> get props => [deviceLanguage];
}

class SignUpFormGenderChanged extends SignUpFormEvent {
  const SignUpFormGenderChanged(this.gender);
  final Gender gender;

  @override
  List<Object> get props => [gender];
}

class SignUpFormLanguageAdded extends SignUpFormEvent {
  const SignUpFormLanguageAdded(this.language);
  final Language language;

  @override
  List<Object> get props => [language];
}

class SignUpFormLanguageRemoved extends SignUpFormEvent {
  const SignUpFormLanguageRemoved(this.language);
  final Language language;

  @override
  List<Object> get props => [language];
}

class SignUpFormNameChanged extends SignUpFormEvent {
  const SignUpFormNameChanged(this.name);
  final String name;

  @override
  List<Object> get props => [name];
}

class SignUpFormNextStep extends SignUpFormEvent {
  const SignUpFormNextStep();
}

class SignUpFormProfileImageChanged extends SignUpFormEvent {
  const SignUpFormProfileImageChanged(this.profileImage);
  final File profileImage;

  @override
  List<Object> get props => [profileImage];
}

class SignUpFormTypeChanged extends SignUpFormEvent {
  const SignUpFormTypeChanged(this.type);
  final UserType type;

  @override
  List<Object> get props => [type];
}
