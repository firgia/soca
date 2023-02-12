/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_input_bloc.dart';

class SignUpInputState extends Equatable {
  final UserType? type;
  final String? name;
  final File? profileImage;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final DeviceLanguage? deviceLanguage;
  final List<Language>? languages;

  const SignUpInputState({
    this.type,
    this.name,
    this.profileImage,
    this.dateOfBirth,
    this.gender,
    this.deviceLanguage,
    this.languages,
  });

  SignUpInputState copyWith({
    UserType? type,
    String? name,
    File? profileImage,
    DateTime? dateOfBirth,
    Gender? gender,
    DeviceLanguage? deviceLanguage,
    List<Language>? languages,
  }) {
    return SignUpInputState(
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

  SignUpPhase get phase {
    if (type != null && languages != null) {
      return SignUpPhase.inputPersonalInformation;
    } else if (type != null) {
      return SignUpPhase.selectLanguage;
    } else {
      return SignUpPhase.selectUserType;
    }
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
