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
      'Should not call userRepository.useDifferentDevice and '
      'userRepository.isDifferentDevice when [checkDifferentDevice] is false',
      build: () => RouteCubit(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
      },
      act: (route) => route.getTargetRoute(checkDifferentDevice: false),
      verify: (bloc) {
        verifyNever(userRepository.useDifferentDevice());
        verifyNever(userRepository.isDifferentDeviceID(any));
      },
    );

    blocTest<RouteCubit, RouteState>(
      'Should call userRepository.useDifferentDevice when [checkDifferentDevice]'
      ' is true and [userDevice] is null',
      build: () => RouteCubit(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
      },
      act: (route) => route.getTargetRoute(checkDifferentDevice: true),
      verify: (bloc) {
        verify(userRepository.useDifferentDevice());
        verifyNever(userRepository.isDifferentDeviceID(any));
      },
    );

    blocTest<RouteCubit, RouteState>(
      'Should call userRepository.isDefferentDevice when '
      '[checkDifferentDevice] is true and [userDevice] is not null',
      build: () => RouteCubit(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
      },
      act: (route) => route.getTargetRoute(
        checkDifferentDevice: true,
        userDevice: const UserDevice(),
      ),
      verify: (bloc) {
        verify(userRepository.isDifferentDeviceID(any));
        verifyNever(userRepository.useDifferentDevice());
      },
    );

    blocTest<RouteCubit, RouteState>(
      'Should emits [RouteLoading, RouteTarget(AppPages.unknownDevice)] when '
      'user use different device.',
      build: () => RouteCubit(),
      act: (route) => route.getTargetRoute(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(userRepository.getProfile())
            .thenAnswer((_) => Future.value(const User()));
        when(userRepository.useDifferentDevice())
            .thenAnswer((_) => Future.value(true));
      },
      expect: () => <RouteState>[
        const RouteLoading(),
        RouteTarget(AppPages.unknownDevice),
      ],
      verify: (bloc) {
        verify(userRepository.useDifferentDevice());
      },
    );

    blocTest<RouteCubit, RouteState>(
      'Should emits [RouteLoading, RouteTarget(AppPages.home)] when user has '
      'been signed in and registered.',
      build: () => RouteCubit(),
      act: (route) => route.getTargetRoute(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(userRepository.getProfile())
            .thenAnswer((_) => Future.value(const User()));
        when(userRepository.useDifferentDevice())
            .thenAnswer((_) => Future.value(false));
      },
      expect: () => <RouteState>[
        const RouteLoading(),
        RouteTarget(AppPages.home),
      ],
      verify: (bloc) {
        verify(userRepository.useDifferentDevice());
      },
    );

    blocTest<RouteCubit, RouteState>(
      'Should emits [RouteLoading, RouteTarget(AppPages.signUp)] when user has '
      'been signed in and not registered.',
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
      'Should emits [RouteLoading, RouteError] when user has been signed in and '
      'and get unknown error].',
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
      'Should emits [RouteLoading, RouteTarget(AppPages.signIn)] when user not '
      'signed in.',
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
