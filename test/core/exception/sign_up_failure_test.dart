/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:soca/core/core.dart';

void main() {
  group("Default Constructor", () {
    test("Should return unknown code as a default", () {
      const exception = SignUpFailure();
      expect(exception.code, SignUpFailureCode.unknown);
    });
  });

  group("From Exception", () {
    test("Should return the correct code from FirebaseFunctionsException", () {
      final unauthenticated = SignUpFailure.fromException(
        FirebaseFunctionsException(
          code: "unauthenticated",
          message: "error",
        ),
      );

      final invalidArgument = SignUpFailure.fromException(
        FirebaseFunctionsException(
          code: "invalid-argument",
          message: "error",
        ),
      );

      final unknown = SignUpFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.unknown,
          message: "error",
        ),
      );

      expect(unauthenticated.code, SignUpFailureCode.unauthenticated);
      expect(invalidArgument.code, SignUpFailureCode.invalidArgument);
      expect(unknown.code, SignUpFailureCode.unknown);
    });

    test("Should return unknown code from Non FirebaseFunctionsException", () {
      final unknown = SignUpFailure.fromException(Exception());
      expect(unknown.code, SignUpFailureCode.unknown);
    });
  });
}
