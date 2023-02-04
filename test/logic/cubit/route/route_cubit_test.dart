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
import 'package:soca/logic/logic.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  group("RouteCubit", () {
    late MockAuthRepository authRepository;

    setUp(() {
      registerLocator();
      authRepository = getMockAuthRepository();
    });
    tearDown(() => unregisterLocator());

    group("getTargetPath", () {
      blocTest<RouteCubit, RouteState>(
        'Should emits [RouteLoading, RouteTarget("/")] when user has been signed in.',
        build: () => RouteCubit(),
        act: (cubit) => cubit.getTargetPath(),
        setUp: () {
          when(authRepository.isSignedIn())
              .thenAnswer((_) => Future.value(true));
        },
        expect: () => const <RouteState>[
          RouteLoading(),
          RouteTarget("/"),
        ],
      );

      blocTest<RouteCubit, RouteState>(
        'Should emits [RouteLoading, RouteTarget("/sign_in")] when user not signed in.',
        build: () => RouteCubit(),
        act: (cubit) => cubit.getTargetPath(),
        setUp: () {
          when(authRepository.isSignedIn())
              .thenAnswer((_) => Future.value(false));
        },
        expect: () => const <RouteState>[
          RouteLoading(),
          RouteTarget("/sign_in"),
        ],
      );
    });
  });
}
