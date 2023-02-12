/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group(".add()", () {
    group("SignUpInputNameChanged()", () {
      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [name] value.',
        build: () => SignUpInputBloc(),
        act: (signUp) {
          signUp.add(const SignUpInputNameChanged("fir"));
          signUp.add(const SignUpInputNameChanged("firgia"));
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(name: "fir"),
          SignUpInputState(name: "firgia"),
        ],
      );
    });

    group("SignUpInputTypeChanged()", () {
      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [type] value.',
        build: () => SignUpInputBloc(),
        act: (signUp) {
          signUp.add(const SignUpInputTypeChanged(UserType.volunteer));
          signUp.add(const SignUpInputTypeChanged(UserType.blind));
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(type: UserType.volunteer),
          SignUpInputState(type: UserType.blind),
        ],
      );
    });

    // TODO: Fix this test
    // group("SignUpInputProfileImageChanged()", () {
    //   blocTest<SignUpInputBloc, SignUpInputState>(
    //     'Should emits [SignUpInputState] and change the [profileImage] value.',
    //     build: () => SignUpInputBloc(),
    //     act: (signUp) {
    //       signUp.add(SignUpInputProfileImageChanged(
    //           File("assets/images/raster/avatar.png")));
    //       signUp.add(SignUpInputProfileImageChanged(
    //           File("assets/images/raster/soca-logo-lg.png")));
    //     },
    //     expect: () => <SignUpInputState>[
    //       SignUpInputState(profileImage: File("assets/images/raster/avatar.png")),
    //       SignUpInputState(
    //           profileImage: File("assets/images/raster/soca-logo-lg.png")),
    //     ],
    //   );
    // });

    group("SignUpInputDateOfBirthChanged()", () {
      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [dateOfBirth] value.',
        build: () => SignUpInputBloc(),
        act: (signUp) {
          signUp.add(SignUpInputDateOfBirthChanged(DateTime(2000)));
          signUp.add(SignUpInputDateOfBirthChanged(DateTime(2001)));
        },
        expect: () => <SignUpInputState>[
          SignUpInputState(dateOfBirth: DateTime(2000)),
          SignUpInputState(dateOfBirth: DateTime(2001)),
        ],
      );
    });

    group("SignUpInputGenderChanged()", () {
      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [gender] value.',
        build: () => SignUpInputBloc(),
        act: (signUp) {
          signUp.add(const SignUpInputGenderChanged(Gender.male));
          signUp.add(const SignUpInputGenderChanged(Gender.female));
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(gender: Gender.male),
          SignUpInputState(gender: Gender.female),
        ],
      );
    });

    group("SignUpInputDeviceLanguageChanged()", () {
      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [deviceLanguage] value.',
        build: () => SignUpInputBloc(),
        act: (signUp) {
          signUp.add(const SignUpInputDeviceLanguageChanged(
              DeviceLanguage.indonesian));
          signUp.add(
              const SignUpInputDeviceLanguageChanged(DeviceLanguage.english));
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(deviceLanguage: DeviceLanguage.indonesian),
          SignUpInputState(deviceLanguage: DeviceLanguage.english),
        ],
      );
    });

    group("SignUpInputLanguagesChanged()", () {
      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [languages] value.',
        build: () => SignUpInputBloc(),
        act: (signUp) {
          signUp.add(const SignUpInputLanguagesChanged([Language(code: "id")]));
          signUp.add(const SignUpInputLanguagesChanged([Language(code: "en")]));
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(languages: [Language(code: "id")]),
          SignUpInputState(languages: [Language(code: "en")]),
        ],
      );
    });
  });
}
