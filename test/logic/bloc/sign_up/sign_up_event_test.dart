/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("SignUpSubmitted", () {
    group(".fromSignUpFormState", () {
      test("Should create [SignUpSubmitted] based on [SignUpFormState] data",
          () {
        SignUpFormState signUpFormState = SignUpFormState(
          dateOfBirth: DateTime(2000),
          deviceLanguage: DeviceLanguage.arabic,
          gender: Gender.male,
          languages: const [Language(code: "id")],
          name: "Firgia",
          profileImage: File("assets/images/raster/avatar.png"),
          type: UserType.volunteer,
        );

        SignUpSubmitted signUpSubmitted =
            SignUpSubmitted.fromSignUpFormState(signUpFormState);

        expect(signUpSubmitted.dateOfBirth, signUpFormState.dateOfBirth);
        expect(signUpSubmitted.deviceLanguage, signUpFormState.deviceLanguage);
        expect(signUpSubmitted.gender, signUpFormState.gender);
        expect(signUpSubmitted.languages, signUpFormState.languages);
        expect(signUpSubmitted.name, signUpFormState.name);
        expect(signUpSubmitted.profileImage, signUpFormState.profileImage);
        expect(signUpSubmitted.type, signUpFormState.type);
      });
    });
  });
}
