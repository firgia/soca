/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 04 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/config/config.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockUserRepository userRepository;

  setUp(() {
    registerLocator();
    authRepository = getMockAuthRepository();
    userRepository = getMockUserRepository();
  });
  tearDown(() => unregisterLocator());

  group(".getTargetRoute()", () {
    blocTest<RouteCubit, RouteState>(
      'Should emits [RouteLoading, RouteTarget(AppPages.home)] when user has been signed in and registered.',
      build: () => RouteCubit(),
      act: (route) => route.getTargetRoute(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(userRepository.getProfile())
            .thenAnswer((_) => Future.value(const User()));
      },
      expect: () => <RouteState>[
        const RouteLoading(),
        RouteTarget(AppPages.home),
      ],
    );

    blocTest<RouteCubit, RouteState>(
      'Should emits [RouteLoading, RouteTarget(AppPages.signUp)] when user has been signed in and not registered.',
      build: () => RouteCubit(),
      act: (route) => route.getTargetRoute(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(userRepository.getProfile())
            .thenThrow(const UserFailure(code: UserFailureCode.notFound));
      },
      expect: () => <RouteState>[
        const RouteLoading(),
        RouteTarget(AppPages.signUp),
      ],
    );

    blocTest<RouteCubit, RouteState>(
      'Should emits [RouteLoading, RouteError] when user has been signed in and and get unknown error].',
      build: () => RouteCubit(),
      act: (route) => route.getTargetRoute(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(userRepository.getProfile()).thenThrow(Exception());
      },
      expect: () => <RouteState>[
        const RouteLoading(),
        RouteError(Exception()),
      ],
    );

    blocTest<RouteCubit, RouteState>(
      'Should emits [RouteLoading, RouteTarget(AppPages.signIn)] when user not signed in.',
      build: () => RouteCubit(),
      act: (route) => route.getTargetRoute(),
      setUp: () {
        when(authRepository.isSignedIn())
            .thenAnswer((_) => Future.value(false));
      },
      expect: () => <RouteState>[
        const RouteLoading(),
        RouteTarget(AppPages.signIn),
      ],
    );
  });
}
