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
  List<Object?> get props => [];
}

class SignUpSubmitted extends SignUpEvent {
  final UserType type;
  final String name;
  final File profileImage;
  final DateTime dateOfBirth;
  final Gender gender;
  final DeviceLanguage deviceLanguage;
  final List<Language> languages;

  const SignUpSubmitted({
    required this.type,
    required this.name,
    required this.profileImage,
    required this.dateOfBirth,
    required this.gender,
    required this.deviceLanguage,
    required this.languages,
  });

  factory SignUpSubmitted.fromSignUpFormState(SignUpFormState signUpFormState) {
    assert(
        signUpFormState.type != null &&
            signUpFormState.name != null &&
            signUpFormState.profileImage != null &&
            signUpFormState.dateOfBirth != null &&
            signUpFormState.gender != null &&
            signUpFormState.deviceLanguage != null &&
            signUpFormState.languages != null,
        "Invalid argument");

    return SignUpSubmitted(
      type: signUpFormState.type!,
      name: signUpFormState.name!,
      profileImage: signUpFormState.profileImage!,
      dateOfBirth: signUpFormState.dateOfBirth!,
      gender: signUpFormState.gender!,
      deviceLanguage: signUpFormState.deviceLanguage!,
      languages: signUpFormState.languages!,
    );
  }

  @override
  List<Object?> get props => [
        type,
        name,
        profileImage,
        dateOfBirth,
        gender,
        deviceLanguage,
        languages,
      ];
}
