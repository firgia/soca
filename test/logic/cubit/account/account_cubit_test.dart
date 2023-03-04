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
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
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

  group(".getAccountData()", () {
    blocTest<AccountCubit, AccountState>(
      'Should emits [AccountLoading(), AccountData()] when user has been signed in.',
      build: () => AccountCubit(),
      act: (account) => account.getAccountData(),
      setUp: () {
        when(authRepository.isSignedIn()).thenAnswer((_) => Future.value(true));
        when(authRepository.getSignInMethod())
            .thenAnswer((_) => Future.value(AuthMethod.apple));
        when(authRepository.email).thenReturn("contact@firgia.com");
      },
      expect: () => <AccountState>[
        const AccountLoading(),
        const AccountData(
          email: "contact@firgia.com",
          signInMethod: AuthMethod.apple,
        ),
      ],
    );

    blocTest<AccountCubit, AccountState>(
      'Should emits [AccountLoading(), AccountEmpty()] when user not signed in.',
      build: () => AccountCubit(),
      act: (account) => account.getAccountData(),
      setUp: () {
        when(authRepository.isSignedIn())
            .thenAnswer((_) => Future.value(false));
      },
      expect: () => <AccountState>[
        const AccountLoading(),
        const AccountEmpty(),
      ],
    );
  });
}
