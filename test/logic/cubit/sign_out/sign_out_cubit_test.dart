/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
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

  group(".signOut()", () {
    blocTest<SignOutCubit, SignOutState>(
      'Should emits [SignOutLoading, SignOutSuccessfully] when succesfully to sign out.',
      build: () => SignOutCubit(),
      act: (signOut) => signOut.signOut(),
      expect: () => const <SignOutState>[
        SignOutLoading(),
        SignOutSuccessfully(),
      ],
    );

    blocTest<SignOutCubit, SignOutState>(
      'Should emits [SignOutLoading, SignOutError] when error to sign out.',
      build: () => SignOutCubit(),
      act: (signOut) => signOut.signOut(),
      setUp: () {
        when(authRepository.signOut()).thenThrow(Exception());
      },
      expect: () => const <SignOutState>[
        SignOutLoading(),
        SignOutError(),
      ],
    );
  });
}
