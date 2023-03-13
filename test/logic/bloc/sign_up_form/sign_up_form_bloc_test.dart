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
    group("SignUpFormBackStep()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [currentStep] value to SignUpStep.selectLanguage when [currentStep] is SignUpStep.inputPersonalInformation.',
        build: () => SignUpFormBloc(),
        seed: () => const SignUpFormState(
          currentStep: SignUpStep.inputPersonalInformation,
        ),
        act: (signUp) {
          signUp.add(const SignUpFormBackStep());
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(
            currentStep: SignUpStep.selectLanguage,
          ),
        ],
      );

      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [currentStep] value to SignUpStep.selectUserType when [currentStep] is SignUpStep.selectLanguage.',
        build: () => SignUpFormBloc(),
        seed: () => const SignUpFormState(
          currentStep: SignUpStep.selectLanguage,
        ),
        act: (signUp) {
          signUp.add(const SignUpFormBackStep());
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(
            currentStep: SignUpStep.selectUserType,
          ),
        ],
      );

      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should not emits [SignUpFormState] when [currentStep] is SignUpStep.selectUserType.',
        build: () => SignUpFormBloc(),
        seed: () => const SignUpFormState(
          currentStep: SignUpStep.selectUserType,
        ),
        act: (signUp) {
          signUp.add(const SignUpFormBackStep());
        },
        expect: () => const <SignUpFormState>[],
      );
    });

    group("SignUpFormDateOfBirthChanged()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [dateOfBirth] value.',
        build: () => SignUpFormBloc(),
        act: (signUp) {
          signUp.add(SignUpFormDateOfBirthChanged(DateTime(2000)));
          signUp.add(SignUpFormDateOfBirthChanged(DateTime(2001)));
        },
        expect: () => <SignUpFormState>[
          SignUpFormState(dateOfBirth: DateTime(2000)),
          SignUpFormState(dateOfBirth: DateTime(2001)),
        ],
      );
    });

    group("SignUpFormDeviceLanguageChanged()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [deviceLanguage] value.',
        build: () => SignUpFormBloc(),
        act: (signUp) {
          signUp.add(
              const SignUpFormDeviceLanguageChanged(DeviceLanguage.indonesian));
          signUp.add(
              const SignUpFormDeviceLanguageChanged(DeviceLanguage.english));
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(deviceLanguage: DeviceLanguage.indonesian),
          SignUpFormState(deviceLanguage: DeviceLanguage.english),
        ],
      );
    });

    group("SignUpFormGenderChanged()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [gender] value.',
        build: () => SignUpFormBloc(),
        act: (signUp) {
          signUp.add(const SignUpFormGenderChanged(Gender.male));
          signUp.add(const SignUpFormGenderChanged(Gender.female));
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(gender: Gender.male),
          SignUpFormState(gender: Gender.female),
        ],
      );
    });
    group("SignUpFormLanguageAdded()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [languages] value.',
        build: () => SignUpFormBloc(),
        act: (signUp) {
          signUp.add(const SignUpFormLanguageAdded(Language(code: "id")));
          signUp.add(const SignUpFormLanguageAdded(Language(code: "en")));
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(languages: [Language(code: "id")]),
          SignUpFormState(languages: [
            Language(code: "id"),
            Language(code: "en"),
          ]),
        ],
      );

      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should note emits [SignUpFormState] and change the [languages] if the language is reach maximum.',
        build: () => SignUpFormBloc(),
        seed: () => const SignUpFormState(languages: [
          Language(code: "id"),
          Language(code: "en"),
          Language(code: "es"),
        ]),
        act: (signUp) {
          signUp.add(const SignUpFormLanguageAdded(Language(code: "id")));
        },
        expect: () => const <SignUpFormState>[],
      );
    });

    group("SignUpFormLanguageRemoved()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [languages] value.',
        build: () => SignUpFormBloc(),
        act: (signUp) {
          signUp.add(const SignUpFormLanguageAdded(Language(code: "id")));
          signUp.add(const SignUpFormLanguageAdded(Language(code: "en")));
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(languages: [Language(code: "id")]),
          SignUpFormState(languages: [
            Language(code: "id"),
            Language(code: "en"),
          ]),
        ],
      );

      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should note emits [SignUpFormState] and change the [languages] if the language is reach maximum.',
        build: () => SignUpFormBloc(),
        seed: () => const SignUpFormState(languages: [
          Language(code: "id"),
          Language(code: "en"),
          Language(code: "es"),
        ]),
        act: (signUp) {
          signUp.add(const SignUpFormLanguageAdded(Language(code: "id")));
        },
        expect: () => const <SignUpFormState>[],
      );
    });

    group("SignUpFormNameChanged()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [name] value.',
        build: () => SignUpFormBloc(),
        act: (signUp) {
          signUp.add(const SignUpFormNameChanged("fir"));
          signUp.add(const SignUpFormNameChanged("firgia"));
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(name: "fir"),
          SignUpFormState(name: "firgia"),
        ],
      );
    });

    group("SignUpFormNextStep()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [currentStep] value to SignUpStep.selectLanguage when [currentStep] is SignUpStep.selectLanguage and [type] is not null.',
        build: () => SignUpFormBloc(),
        seed: () => const SignUpFormState(
          currentStep: SignUpStep.selectUserType,
          type: UserType.blind,
        ),
        act: (signUp) {
          signUp.add(const SignUpFormNextStep());
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(
            currentStep: SignUpStep.selectLanguage,
            type: UserType.blind,
          ),
        ],
      );

      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should not emits [SignUpFormState] and change the [currentStep] value to SignUpStep.selectLanguage when [type] is null.',
        build: () => SignUpFormBloc(),
        seed: () =>
            const SignUpFormState(currentStep: SignUpStep.selectUserType),
        act: (signUp) {
          signUp.add(const SignUpFormNextStep());
        },
        expect: () => const <SignUpFormState>[],
      );

      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [currentStep] value to SignUpStep.inputPersonalInformation when [currentStep] is SignUpStep.selectUserType and [type] & [languages] is not null.',
        build: () => SignUpFormBloc(),
        seed: () => const SignUpFormState(
          currentStep: SignUpStep.selectLanguage,
          type: UserType.blind,
          languages: [Language(code: "id")],
        ),
        act: (signUp) {
          signUp.add(const SignUpFormNextStep());
          signUp.add(const SignUpFormNextStep());
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(
            currentStep: SignUpStep.inputPersonalInformation,
            type: UserType.blind,
            languages: [Language(code: "id")],
          ),
        ],
      );

      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should not emits [SignUpFormState] and change the [currentStep] value to SignUpStep.inputPersonalInformation when [type] or [languages] is null.',
        build: () => SignUpFormBloc(),
        seed: () => const SignUpFormState(
          currentStep: SignUpStep.selectLanguage,
        ),
        act: (signUp) {
          signUp.add(const SignUpFormNextStep());
          signUp.add(const SignUpFormNextStep());
        },
        expect: () => const <SignUpFormState>[],
      );
    });

    // TODO: Fix this test
    // group("SignUpFormProfileImageChanged()", () {
    //   blocTest<SignUpFormBloc, SignUpFormState>(
    //     'Should emits [SignUpFormState] and change the [profileImage] value.',
    //     build: () => SignUpFormBloc(),
    //     act: (signUp) {
    //       signUp.add(SignUpFormProfileImageChanged(
    //           File("assets/images/raster/avatar.png")));
    //       signUp.add(SignUpFormProfileImageChanged(
    //           File("assets/images/raster/soca-logo-lg.png")));
    //     },
    //     expect: () => <SignUpFormState>[
    //       SignUpFormState(profileImage: File("assets/images/raster/avatar.png")),
    //       SignUpFormState(
    //           profileImage: File("assets/images/raster/soca-logo-lg.png")),
    //     ],
    //   );
    // });

    group("SignUpFormTypeChanged()", () {
      blocTest<SignUpFormBloc, SignUpFormState>(
        'Should emits [SignUpFormState] and change the [type] value.',
        build: () => SignUpFormBloc(),
        act: (signUp) {
          signUp.add(const SignUpFormTypeChanged(UserType.volunteer));
          signUp.add(const SignUpFormTypeChanged(UserType.blind));
        },
        expect: () => const <SignUpFormState>[
          SignUpFormState(type: UserType.volunteer),
          SignUpFormState(type: UserType.blind),
        ],
      );
    });
  });
}
