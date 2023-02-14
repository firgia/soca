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

    group("SignUpInputNextStep()", () {
      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [currentStep] value to SignUpStep.selectLanguage when [currentStep] is SignUpStep.selectLanguage and [type] is not null.',
        build: () => SignUpInputBloc(),
        seed: () => const SignUpInputState(
          currentStep: SignUpStep.selectUserType,
          type: UserType.blind,
        ),
        act: (signUp) {
          signUp.add(const SignUpInputNextStep());
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(
            currentStep: SignUpStep.selectLanguage,
            type: UserType.blind,
          ),
        ],
      );

      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should not emits [SignUpInputState] and change the [currentStep] value to SignUpStep.selectLanguage when [type] is null.',
        build: () => SignUpInputBloc(),
        seed: () =>
            const SignUpInputState(currentStep: SignUpStep.selectUserType),
        act: (signUp) {
          signUp.add(const SignUpInputNextStep());
        },
        expect: () => const <SignUpInputState>[],
      );

      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [currentStep] value to SignUpStep.inputPersonalInformation when [currentStep] is SignUpStep.selectUserType and [type] & [languages] is not null.',
        build: () => SignUpInputBloc(),
        seed: () => const SignUpInputState(
          currentStep: SignUpStep.selectLanguage,
          type: UserType.blind,
          languages: [Language(code: "id")],
        ),
        act: (signUp) {
          signUp.add(const SignUpInputNextStep());
          signUp.add(const SignUpInputNextStep());
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(
            currentStep: SignUpStep.inputPersonalInformation,
            type: UserType.blind,
            languages: [Language(code: "id")],
          ),
        ],
      );

      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should not emits [SignUpInputState] and change the [currentStep] value to SignUpStep.inputPersonalInformation when [type] or [languages] is null.',
        build: () => SignUpInputBloc(),
        seed: () => const SignUpInputState(
          currentStep: SignUpStep.selectLanguage,
        ),
        act: (signUp) {
          signUp.add(const SignUpInputNextStep());
          signUp.add(const SignUpInputNextStep());
        },
        expect: () => const <SignUpInputState>[],
      );
    });

    group("SignUpInputBackStep()", () {
      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [currentStep] value to SignUpStep.selectLanguage when [currentStep] is SignUpStep.inputPersonalInformation.',
        build: () => SignUpInputBloc(),
        seed: () => const SignUpInputState(
          currentStep: SignUpStep.inputPersonalInformation,
        ),
        act: (signUp) {
          signUp.add(const SignUpInputBackStep());
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(
            currentStep: SignUpStep.selectLanguage,
          ),
        ],
      );

      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should emits [SignUpInputState] and change the [currentStep] value to SignUpStep.selectUserType when [currentStep] is SignUpStep.selectLanguage.',
        build: () => SignUpInputBloc(),
        seed: () => const SignUpInputState(
          currentStep: SignUpStep.selectLanguage,
        ),
        act: (signUp) {
          signUp.add(const SignUpInputBackStep());
        },
        expect: () => const <SignUpInputState>[
          SignUpInputState(
            currentStep: SignUpStep.selectUserType,
          ),
        ],
      );

      blocTest<SignUpInputBloc, SignUpInputState>(
        'Should not emits [SignUpInputState] when [currentStep] is SignUpStep.selectUserType.',
        build: () => SignUpInputBloc(),
        seed: () => const SignUpInputState(
          currentStep: SignUpStep.selectUserType,
        ),
        act: (signUp) {
          signUp.add(const SignUpInputBackStep());
        },
        expect: () => const <SignUpInputState>[],
      );
    });
  });
}
