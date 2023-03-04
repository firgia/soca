/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("SignInWithAppleError", () {
    group(".failure", () {
      test("Should return failure value based on constructor", () {
        const signInError = SignInWithAppleError(
          SignInWithAppleFailure(code: SignInWithAppleFailureCode.failed),
        );

        expect(
          signInError.failure,
          const SignInWithAppleFailure(code: SignInWithAppleFailureCode.failed),
        );
      });
    });
  });

  group("SignInWithGoogleError", () {
    group(".failure", () {
      test("Should return failure value based on constructor", () {
        const signInError = SignInWithGoogleError(
          SignInWithGoogleFailure(
              code: SignInWithGoogleFailureCode.userDisabled),
        );

        expect(
          signInError.failure,
          const SignInWithGoogleFailure(
              code: SignInWithGoogleFailureCode.userDisabled),
        );
      });
    });
  });
}
