/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    registerLocator();
    authRepository = getMockAuthRepository();
  });

  tearDown(() => unregisterLocator());

  group(".add()", () {
    group("SignUpSubmitted()", () {
      blocTest<SignUpBloc, SignUpState>(
        'Should emits [SignUpLoading, SignUpSuccessfully] when successfully to sign up.',
        build: () => SignUpBloc(),
        act: (signUp) {
          signUp.add(SignUpSubmitted(
            dateOfBirth: DateTime(2000),
            deviceLanguage: DeviceLanguage.indonesian,
            gender: Gender.male,
            languages: const [Language(code: "id")],
            name: "Firgia",
            profileImage: File("assets/images/raster/avatar.png"),
            type: UserType.volunteer,
          ));
        },
        expect: () => const <SignUpState>[
          SignUpLoading(),
          SignUpSuccessfully(),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'Should emits [SignUpLoading, SignUpError] when error to sign up.',
        build: () => SignUpBloc(),
        setUp: () {
          when(authRepository.signUp(
            type: anyNamed("type"),
            name: anyNamed("name"),
            dateOfBirth: anyNamed("dateOfBirth"),
            gender: anyNamed("gender"),
            deviceLanguage: anyNamed("deviceLanguage"),
            languages: anyNamed("languages"),
            profileImage: anyNamed("profileImage"),
          )).thenThrow(const SignUpFailure());
        },
        act: (signUp) {
          signUp.add(SignUpSubmitted(
            dateOfBirth: DateTime(2000),
            deviceLanguage: DeviceLanguage.indonesian,
            gender: Gender.male,
            languages: const [Language(code: "id")],
            name: "Firgia",
            profileImage: File("assets/images/raster/avatar.png"),
            type: UserType.volunteer,
          ));
        },
        expect: () => const <SignUpState>[
          SignUpLoading(),
          SignUpError(SignUpFailure()),
        ],
      );
    });
  });
}
