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
    group(".fromSignUpInputState", () {
      test("Should create [SignUpSubmitted] based on [SignUpInputState] data",
          () {
        SignUpInputState signUpInputState = SignUpInputState(
          dateOfBirth: DateTime(2000),
          deviceLanguage: DeviceLanguage.arabic,
          gender: Gender.male,
          languages: const [Language(code: "id")],
          name: "Firgia",
          profileImage: File("assets/images/raster/avatar.png"),
          type: UserType.volunteer,
        );

        SignUpSubmitted signUpSubmitted =
            SignUpSubmitted.fromSignUpInputState(signUpInputState);

        expect(signUpSubmitted.dateOfBirth, signUpInputState.dateOfBirth);
        expect(signUpSubmitted.deviceLanguage, signUpInputState.deviceLanguage);
        expect(signUpSubmitted.gender, signUpInputState.gender);
        expect(signUpSubmitted.languages, signUpInputState.languages);
        expect(signUpSubmitted.name, signUpInputState.name);
        expect(signUpSubmitted.profileImage, signUpInputState.profileImage);
        expect(signUpSubmitted.type, signUpInputState.type);
      });
    });
  });
}
