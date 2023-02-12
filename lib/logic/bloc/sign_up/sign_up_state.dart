/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final UserType? type;
  final String? name;
  final File? profileImage;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final DeviceLanguage? deviceLanguage;
  final List<Language>? languages;

  const SignUpState({
    this.type,
    this.name,
    this.profileImage,
    this.dateOfBirth,
    this.gender,
    this.deviceLanguage,
    this.languages,
  });

  SignUpState copyWith({
    UserType? type,
    String? name,
    File? profileImage,
    DateTime? dateOfBirth,
    Gender? gender,
    DeviceLanguage? deviceLanguage,
    List<Language>? languages,
  }) {
    return SignUpState(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      deviceLanguage: deviceLanguage ?? this.deviceLanguage,
      gender: gender ?? this.gender,
      languages: languages ?? this.languages,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      type: type ?? this.type,
    );
  }

  bool get isValidToSubmit => (type != null &&
      name != null &&
      profileImage != null &&
      dateOfBirth != null &&
      gender != null &&
      languages != null);

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

class SignUpSuccessfully extends SignUpState {
  const SignUpSuccessfully();
}

class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

class SignUpFailed extends SignUpState {
  const SignUpFailed();
}

class SignUpError extends SignUpState {
  final SignUpFailure? failure;
  const SignUpError([this.failure]);

  @override
  List<Object?> get props =>
      super.props +
      [
        failure,
      ];
}
