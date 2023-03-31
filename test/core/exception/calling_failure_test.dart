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
      const exception = CallingFailure();
      expect(exception.code, CallingFailureCode.unknown);
    });
  });

  group(".fromException()", () {
    test("Should return the correct code from FirebaseFunctionsException", () {
      final invalidArgument = CallingFailure.fromException(
        FirebaseFunctionsException(
          code: "invalid-argument",
          message: "error",
        ),
      );

      final notFound = CallingFailure.fromException(
        FirebaseFunctionsException(
          code: "not-found",
          message: "error",
        ),
      );

      final unauthenticated = CallingFailure.fromException(
        FirebaseFunctionsException(
          code: "unauthenticated",
          message: "error",
        ),
      );

      final permissionDenied = CallingFailure.fromException(
        FirebaseFunctionsException(
          code: "permission-denied",
          message: "error",
        ),
      );

      final unknown = CallingFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.unknown,
          message: "error",
        ),
      );

      expect(invalidArgument.code, CallingFailureCode.invalidArgument);
      expect(notFound.code, CallingFailureCode.notFound);
      expect(unauthenticated.code, CallingFailureCode.unauthenticated);
      expect(permissionDenied.code, CallingFailureCode.permissionDenied);
      expect(unknown.code, CallingFailureCode.unknown);
    });

    test("Should return unknown code from Non FirebaseFunctionsException", () {
      final unknown = CallingFailure.fromException(Exception());
      expect(unknown.code, CallingFailureCode.unknown);
    });
  });
}
