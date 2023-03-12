/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

part of 'sign_up_form_bloc.dart';

class SignUpFormState extends Equatable with ValidateName {
  final SignUpStep currentStep;
  final DateTime? dateOfBirth;
  final DeviceLanguage? deviceLanguage;
  final Gender? gender;
  final List<Language>? languages;
  final String? name;
  final File? profileImage;
  final UserType? type;

  const SignUpFormState({
    this.currentStep = SignUpStep.selectUserType,
    this.dateOfBirth,
    this.deviceLanguage,
    this.gender,
    this.languages,
    this.name,
    this.profileImage,
    this.type,
  });

  SignUpFormState copyWith({
    SignUpStep? currentStep,
    DateTime? dateOfBirth,
    DeviceLanguage? deviceLanguage,
    Gender? gender,
    List<Language>? languages,
    String? name,
    File? profileImage,
    UserType? type,
  }) {
    return SignUpFormState(
      currentStep: currentStep ?? this.currentStep,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      deviceLanguage: deviceLanguage ?? this.deviceLanguage,
      gender: gender ?? this.gender,
      languages: languages ?? this.languages,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      type: type ?? this.type,
    );
  }

  bool isValidToSubmit() => (type != null &&
      name != null &&
      profileImage != null &&
      dateOfBirth != null &&
      gender != null &&
      languages != null &&
      validateName(name) == null);

  bool isCanNext() {
    switch (currentStep) {
      case SignUpStep.selectUserType:
        if (validStep == SignUpStep.selectLanguage ||
            validStep == SignUpStep.inputPersonalInformation) {
          return true;
        }
        break;
      case SignUpStep.selectLanguage:
        if (validStep == SignUpStep.inputPersonalInformation) {
          return true;
        }
        break;
      default:
        break;
    }

    return false;
  }

  bool isCanAddLanguage() =>
      languages == null ? true : (languages!.length < _maxLanguage);

  SignUpStep get validStep {
    if (type != null && (languages?.isNotEmpty ?? false)) {
      return SignUpStep.inputPersonalInformation;
    } else if (type != null) {
      return SignUpStep.selectLanguage;
    } else {
      return SignUpStep.selectUserType;
    }
  }

  @override
  List<Object?> get props => [
        currentStep,
        dateOfBirth,
        deviceLanguage,
        gender,
        languages,
        name,
        profileImage,
        type,
        validStep,
      ];
}
