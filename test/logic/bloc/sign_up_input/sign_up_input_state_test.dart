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
  group("SignUpInputState", () {
    late SignUpInputState defaultState;

    setUp(() {
      defaultState = SignUpInputState(
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
        SignUpInputState state = SignUpInputState(
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
  });
}