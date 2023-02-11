/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:soca/core/core.dart';

void main() {
  group(".()", () {
    test("Should return unknown code as a default", () {
      const exception = UserFailure();
      expect(exception.code, UserFailureCode.unknown);
    });
  });

  group(".fromException()", () {
    test("Should return the correct code from FirebaseFunctionsException", () {
      final invalidArgument = UserFailure.fromException(
        FirebaseFunctionsException(
          code: "invalid-argument",
          message: "error",
        ),
      );

      final notFound = UserFailure.fromException(
        FirebaseFunctionsException(
          code: "not-found",
          message: "error",
        ),
      );

      final unauthenticated = UserFailure.fromException(
        FirebaseFunctionsException(
          code: "unauthenticated",
          message: "error",
        ),
      );
      final unknown = UserFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.unknown,
          message: "error",
        ),
      );

      expect(invalidArgument.code, UserFailureCode.invalidArgument);
      expect(notFound.code, UserFailureCode.notFound);
      expect(unauthenticated.code, UserFailureCode.unauthenticated);
      expect(unknown.code, UserFailureCode.unknown);
    });

    test("Should return unknown code from Non FirebaseFunctionsException", () {
      final unknown = UserFailure.fromException(Exception());
      expect(unknown.code, UserFailureCode.unknown);
    });
  });
}
