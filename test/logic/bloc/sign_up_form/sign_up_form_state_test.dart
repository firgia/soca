/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("SignUpFormState", () {
    late SignUpFormState defaultState;

    setUp(() {
      defaultState = SignUpFormState(
        dateOfBirth: DateTime(2000),
        deviceLanguage: DeviceLanguage.arabic,
        gender: Gender.male,
        languages: const [Language(code: "id")],
        name: "Firgia",
        profileImage: File("assets/images/raster/avatar.png"),
        type: UserType.volunteer,
      );
    });

    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        SignUpFormState state = SignUpFormState(
          dateOfBirth: DateTime(2000),
          deviceLanguage: DeviceLanguage.arabic,
          gender: Gender.male,
          languages: const [Language(code: "id")],
          name: "Firgia",
          profileImage: File("assets/images/raster/avatar.png"),
          type: UserType.volunteer,
        );

        expect(state.dateOfBirth, DateTime(2000));
        expect(state.deviceLanguage, DeviceLanguage.arabic);
        expect(state.gender, Gender.male);
        expect(state.languages, const [Language(code: "id")]);
        expect(state.name, "Firgia");
        expect(state.profileImage!.path, "assets/images/raster/avatar.png");
        expect(state.type, UserType.volunteer);
      });
    });

    group(".validStep", () {
      test(
          "Should return [SignUpStep.inputPersonalInformation] when [type] and [languages] is not empty",
          () {
        SignUpFormState state = SignUpFormState(
          dateOfBirth: DateTime(2000),
          deviceLanguage: DeviceLanguage.arabic,
          gender: Gender.male,
          languages: const [Language(code: "id")],
          name: "Firgia",
          profileImage: File("assets/images/raster/avatar.png"),
          type: UserType.volunteer,
        );

        expect(state.validStep, SignUpStep.inputPersonalInformation);
      });

      test("Should return [SignUpStep.selectLanguage] when [type] is not null",
          () {
        SignUpFormState state = const SignUpFormState(
          languages: null,
          type: UserType.volunteer,
        );

        expect(state.validStep, SignUpStep.selectLanguage);
      });

      test("Should return [SignUpStep.selectLanguage] when [type] is null", () {
        SignUpFormState state = const SignUpFormState(
          type: null,
        );

        expect(state.validStep, SignUpStep.selectUserType);
      });
    });

    group(".copyWith()", () {
      test("Should copy the dateOfBirth", () {
        final state = defaultState.copyWith(dateOfBirth: DateTime(2001));

        expect(state.dateOfBirth, DateTime(2001));
        expect(state.deviceLanguage, DeviceLanguage.arabic);
        expect(state.gender, Gender.male);
        expect(state.languages, const [Language(code: "id")]);
        expect(state.name, "Firgia");
        expect(state.profileImage!.path, "assets/images/raster/avatar.png");
        expect(state.type, UserType.volunteer);
      });

      test("Should copy the deviceLanguage", () {
        final state =
            defaultState.copyWith(deviceLanguage: DeviceLanguage.indonesian);

        expect(state.dateOfBirth, DateTime(2000));
        expect(state.deviceLanguage, DeviceLanguage.indonesian);
        expect(state.gender, Gender.male);
        expect(state.languages, const [Language(code: "id")]);
        expect(state.name, "Firgia");
        expect(state.profileImage!.path, "assets/images/raster/avatar.png");
        expect(state.type, UserType.volunteer);
      });

      test("Should copy the gender", () {
        final state = defaultState.copyWith(gender: Gender.female);

        expect(state.dateOfBirth, DateTime(2000));
        expect(state.deviceLanguage, DeviceLanguage.arabic);
        expect(state.gender, Gender.female);
        expect(state.languages, const [Language(code: "id")]);
        expect(state.name, "Firgia");
        expect(state.profileImage!.path, "assets/images/raster/avatar.png");
        expect(state.type, UserType.volunteer);
      });

      test("Should copy the languages", () {
        final state =
            defaultState.copyWith(languages: const [Language(code: "en")]);

        expect(state.dateOfBirth, DateTime(2000));
        expect(state.deviceLanguage, DeviceLanguage.arabic);
        expect(state.gender, Gender.male);
        expect(state.languages, const [Language(code: "en")]);
        expect(state.name, "Firgia");
        expect(state.profileImage!.path, "assets/images/raster/avatar.png");
        expect(state.type, UserType.volunteer);
      });

      test("Should copy the name", () {
        final state = defaultState.copyWith(name: "Mochamad Firgia");

        expect(state.dateOfBirth, DateTime(2000));
        expect(state.deviceLanguage, DeviceLanguage.arabic);
        expect(state.gender, Gender.male);
        expect(state.languages, const [Language(code: "id")]);
        expect(state.name, "Mochamad Firgia");
        expect(state.profileImage!.path, "assets/images/raster/avatar.png");
        expect(state.type, UserType.volunteer);
      });

      test("Should copy the profileImage", () {
        final state = defaultState.copyWith(
            profileImage: File("assets/images/raster/soca-logo-lg.png"));

        expect(state.dateOfBirth, DateTime(2000));
        expect(state.deviceLanguage, DeviceLanguage.arabic);
        expect(state.gender, Gender.male);
        expect(state.languages, const [Language(code: "id")]);
        expect(state.name, "Firgia");
        expect(
            state.profileImage!.path, "assets/images/raster/soca-logo-lg.png");
        expect(state.type, UserType.volunteer);
      });

      test("Should copy the type", () {
        final state = defaultState.copyWith(type: UserType.blind);

        expect(state.dateOfBirth, DateTime(2000));
        expect(state.deviceLanguage, DeviceLanguage.arabic);
        expect(state.gender, Gender.male);
        expect(state.languages, const [Language(code: "id")]);
        expect(state.name, "Firgia");
        expect(state.profileImage!.path, "assets/images/raster/avatar.png");
        expect(state.type, UserType.blind);
      });
    });

    group(".isCanNext()", () {
      group("When [currentStep] is [SignUpStep.selectUserType]", () {
        test("Should return true when [type] is not null", () {
          SignUpFormState formState =
              const SignUpFormState(type: UserType.blind);

          expect(formState.isCanNext(), true);
        });

        test("Should return false when [type] is null", () {
          SignUpFormState formState = const SignUpFormState();

          expect(formState.isCanNext(), false);
        });
      });

      group("When [currentStep] is [SignUpStep.selectLanguage]", () {
        test("Should return true when [type] and [language] is not null", () {
          SignUpFormState formState = const SignUpFormState(
            type: UserType.blind,
            languages: [
              Language(code: "id"),
            ],
            currentStep: SignUpStep.selectLanguage,
          );

          expect(formState.isCanNext(), true);
        });

        test("Should return false when [type] or [language] is null", () {
          SignUpFormState formState = const SignUpFormState(
            type: UserType.blind,
            currentStep: SignUpStep.selectLanguage,
          );

          expect(formState.isCanNext(), false);
        });
      });

      group("When [currentStep] is [SignUpStep.inputPersonalInformation]", () {
        test("Should always return false", () {
          SignUpFormState formState = const SignUpFormState(
            type: UserType.blind,
            languages: [
              Language(code: "id"),
            ],
            currentStep: SignUpStep.inputPersonalInformation,
          );

          expect(formState.isCanNext(), false);
        });
      });
    });

    group(".isValidToSubmit()", () {
      test("Should return true when all field is not empty", () {
        SignUpFormState signUpFormState = SignUpFormState(
          dateOfBirth: DateTime(2000),
          deviceLanguage: DeviceLanguage.arabic,
          gender: Gender.male,
          languages: const [Language(code: "id")],
          name: "Firgia",
          profileImage: File("assets/images/raster/avatar.png"),
          type: UserType.volunteer,
        );

        expect(signUpFormState.isValidToSubmit(), true);
      });

      test(
          "Should return true when all field is not empty except [deviceLanguage]",
          () {
        SignUpFormState signUpFormState = SignUpFormState(
          dateOfBirth: DateTime(2000),
          deviceLanguage: null,
          gender: Gender.male,
          languages: const [Language(code: "id")],
          name: "Firgia",
          profileImage: File("assets/images/raster/avatar.png"),
          type: UserType.volunteer,
        );

        expect(signUpFormState.isValidToSubmit(), true);
      });

      test(
          "Should return false when name is invalid even all input is not empty",
          () {
        SignUpFormState signUpFormState = SignUpFormState(
          dateOfBirth: DateTime(2000),
          deviceLanguage: DeviceLanguage.arabic,
          gender: Gender.male,
          languages: const [Language(code: "id")],
          name: ".a",
          profileImage: File("assets/images/raster/avatar.png"),
          type: UserType.volunteer,
        );

        expect(signUpFormState.isValidToSubmit(), false);
      });

      test("Should return false when some field is empty", () {
        SignUpFormState signUpFormState = SignUpFormState(
          dateOfBirth: DateTime(2000),
          deviceLanguage: null,
          gender: null,
          languages: const [Language(code: "id")],
          name: "Firgia",
          profileImage: File("assets/images/raster/avatar.png"),
          type: UserType.volunteer,
        );

        expect(signUpFormState.isValidToSubmit(), false);
      });
    });
  });
}
