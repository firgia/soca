/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/logic/bloc/bloc.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  group("SignOutBloc", () {
    late MockAuthRepository authRepository;
    setUp(() {
      registerLocator();
      authRepository = getMockAuthRepository();
    });
    tearDown(() => unregisterLocator());

    group("SignOutExecute", () {
      blocTest<SignOutBloc, SignOutState>(
        'Should emits [SignOutLoading, SignOutSuccessfully] when succesfully to sign out.',
        build: () => SignOutBloc(),
        act: (bloc) => bloc.add(const SignOutExecute()),
        expect: () => const <SignOutState>[
          SignOutLoading(),
          SignOutSuccessfully(),
        ],
      );

      blocTest<SignOutBloc, SignOutState>(
        'Should emits [SignOutLoading, SignOutError] when error to sign out.',
        build: () => SignOutBloc(),
        act: (bloc) => bloc.add(const SignOutExecute()),
        setUp: () {
          when(authRepository.signOut()).thenThrow(Exception());
        },
        expect: () => const <SignOutState>[
          SignOutLoading(),
          SignOutError(),
        ],
      );
    });
  });
}
