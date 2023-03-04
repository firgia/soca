/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/bloc/bloc.dart';

import '../../../helper/helper.dart';
import '../../../mock/mock.mocks.dart';

void main() {
  group("SignInBloc", () {
    late MockAuthRepository authRepository;
    setUp(() {
      registerLocator();
      authRepository = getMockAuthRepository();
    });
    tearDown(() => unregisterLocator());

    group(".add()", () {
      group("SignInWithApple", () {
        const signInWithAppleFailure =
            SignInWithAppleFailure(code: SignInWithAppleFailureCode.failed);

        blocTest<SignInBloc, SignInState>(
          'Should emits [SignInLoading, SignInSuccessfully] when succesfully to sign in with Apple.',
          build: () => SignInBloc(),
          act: (bloc) => bloc.add(const SignInWithApple()),
          setUp: () {
            when(authRepository.signInWithApple())
                .thenAnswer((_) => Future.value(true));
          },
          expect: () => const <SignInState>[
            SignInLoading(),
            SignInSuccessfully(),
          ],
        );

        blocTest<SignInBloc, SignInState>(
          'Should emits [SignInLoading, SignInFailed] when failed to sign in with Apple.',
          build: () => SignInBloc(),
          act: (bloc) => bloc.add(const SignInWithApple()),
          setUp: () {
            when(authRepository.signInWithApple())
                .thenAnswer((_) => Future.value(false));
          },
          expect: () => const <SignInState>[
            SignInLoading(),
            SignInFailed(),
          ],
        );

        blocTest<SignInBloc, SignInState>(
          'Should emits [SignInLoading, SignInWithAppleError] when error to sign in with Apple.',
          build: () => SignInBloc(),
          act: (bloc) => bloc.add(const SignInWithApple()),
          setUp: () {
            when(authRepository.signInWithApple())
                .thenThrow(signInWithAppleFailure);
          },
          expect: () => const <SignInState>[
            SignInLoading(),
            SignInWithAppleError(signInWithAppleFailure),
          ],
        );

        blocTest<SignInBloc, SignInState>(
          'Should emits [SignInLoading, SignInError] when unpredictable error to sign in with Apple.',
          build: () => SignInBloc(),
          act: (bloc) => bloc.add(const SignInWithApple()),
          setUp: () {
            when(authRepository.signInWithApple()).thenThrow(Exception());
          },
          expect: () => const <SignInState>[
            SignInLoading(),
            SignInError(),
          ],
        );
      });

      group("SignInWithGoogle", () {
        const signInWithGoogleFailure = SignInWithGoogleFailure(
            code: SignInWithGoogleFailureCode.userDisabled);

        blocTest<SignInBloc, SignInState>(
          'Should emits [SignInLoading, SignInSuccessfully] when succesfully to sign in with Google.',
          build: () => SignInBloc(),
          act: (bloc) => bloc.add(const SignInWithGoogle()),
          setUp: () {
            when(authRepository.signInWithGoogle())
                .thenAnswer((_) => Future.value(true));
          },
          expect: () => const <SignInState>[
            SignInLoading(),
            SignInSuccessfully(),
          ],
        );

        blocTest<SignInBloc, SignInState>(
          'Should emits [SignInLoading, SignInFailed] when failed to sign in with Google.',
          build: () => SignInBloc(),
          act: (bloc) => bloc.add(const SignInWithGoogle()),
          setUp: () {
            when(authRepository.signInWithGoogle())
                .thenAnswer((_) => Future.value(false));
          },
          expect: () => const <SignInState>[
            SignInLoading(),
            SignInFailed(),
          ],
        );

        blocTest<SignInBloc, SignInState>(
          'Should emits [SignInLoading, SignInWithGoogleError] when error to sign in with Google.',
          build: () => SignInBloc(),
          act: (bloc) => bloc.add(const SignInWithGoogle()),
          setUp: () {
            when(authRepository.signInWithGoogle())
                .thenThrow(signInWithGoogleFailure);
          },
          expect: () => const <SignInState>[
            SignInLoading(),
            SignInWithGoogleError(signInWithGoogleFailure),
          ],
        );

        blocTest<SignInBloc, SignInState>(
          'Should emits [SignInLoading, SignInError] when unpredictable error to sign in with Google.',
          build: () => SignInBloc(),
          act: (bloc) => bloc.add(const SignInWithGoogle()),
          setUp: () {
            when(authRepository.signInWithGoogle()).thenThrow(Exception());
          },
          expect: () => const <SignInState>[
            SignInLoading(),
            SignInError(),
          ],
        );
      });
    });
  });
}
