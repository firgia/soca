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
      const exception = SignInWithAppleFailure();
      expect(exception.code, SignInWithAppleFailureCode.unknown);
    });
  });

  group("From Code", () {
    test(
        "Should return the correct code from SignInWithAppleNotSupportedException",
        () {
      const signInWithAppleNotSupportedException =
          SignInWithAppleNotSupportedException(message: "error");

      final notSupported = SignInWithAppleFailure.fromException(
          signInWithAppleNotSupportedException);

      expect(notSupported.code, SignInWithAppleFailureCode.notSupportedDevice);
    });

    test(
        "Should return the correct code from SignInWithAppleCredentialsException",
        () {
      const signInWithAppleCredentialsException =
          SignInWithAppleCredentialsException(message: "error");

      final invalidCredentials = SignInWithAppleFailure.fromException(
          signInWithAppleCredentialsException);

      expect(invalidCredentials.code,
          SignInWithAppleFailureCode.invalidCredential);
    });

    test(
        "Should return the correct code from SignInWithAppleAuthorizationException",
        () {
      final canceled = SignInWithAppleFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.canceled,
          message: "error",
        ),
      );

      final failed = SignInWithAppleFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.failed,
          message: "error",
        ),
      );

      final invalidResponse = SignInWithAppleFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.invalidResponse,
          message: "error",
        ),
      );

      final notHandled = SignInWithAppleFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.notHandled,
          message: "error",
        ),
      );

      final notInteractive = SignInWithAppleFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.notInteractive,
          message: "error",
        ),
      );

      final unknown = SignInWithAppleFailure.fromException(
        const SignInWithAppleAuthorizationException(
          code: AuthorizationErrorCode.unknown,
          message: "error",
        ),
      );

      expect(canceled.code, SignInWithAppleFailureCode.canceled);
      expect(failed.code, SignInWithAppleFailureCode.failed);
      expect(invalidResponse.code, SignInWithAppleFailureCode.invalidResponse);
      expect(notHandled.code, SignInWithAppleFailureCode.notHandled);
      expect(notInteractive.code, SignInWithAppleFailureCode.notInteractive);
      expect(unknown.code, SignInWithAppleFailureCode.unknown);
    });

    test("Should return unknow code from Non SignInWithAppleException", () {
      final unknown = SignInWithAppleFailure.fromException(
        FirebaseFunctionsException(code: "unknown", message: "test"),
      );

      expect(unknown.code, SignInWithAppleFailureCode.unknown);
    });
  });
}
