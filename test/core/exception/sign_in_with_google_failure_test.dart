/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group("Default Constructor", () {
    test("Should return unknown code as a default", () {
      const exception = SignInWithGoogleFailure();
      expect(exception.code, SignInWithGoogleFailureCode.unknown);
    });
  });

  group("From Code", () {
    test("Should return code based on string code", () {
      final invalidCredential =
          SignInWithGoogleFailure.fromCode("invalid-credential");
      final accountExistsWithDifferentCredential =
          SignInWithGoogleFailure.fromCode(
              "account-exists-with-different-credential");
      final userDisabled = SignInWithGoogleFailure.fromCode("user-disabled");
      final operationNotAllowed =
          SignInWithGoogleFailure.fromCode("operation-not-allowed");
      final networkRequestFailed =
          SignInWithGoogleFailure.fromCode("network-request-failed");
      final unknown = SignInWithGoogleFailure.fromCode("abc");

      expect(
        invalidCredential.code,
        SignInWithGoogleFailureCode.invalidCredential,
      );
      expect(
        accountExistsWithDifferentCredential.code,
        SignInWithGoogleFailureCode.accountExistsWithDifferentCredential,
      );
      expect(
        userDisabled.code,
        SignInWithGoogleFailureCode.userDisabled,
      );
      expect(
        operationNotAllowed.code,
        SignInWithGoogleFailureCode.operationNotAllowed,
      );
      expect(
        networkRequestFailed.code,
        SignInWithGoogleFailureCode.networkRequestFailed,
      );
      expect(
        unknown.code,
        SignInWithGoogleFailureCode.unknown,
      );
    });
  });

  group("From Exception", () {
    test("Should return correct code from FirebaseAuthException ", () {
      final invalidCredential = SignInWithGoogleFailure.fromException(
        FirebaseAuthException(code: "invalid-credential"),
      );

      expect(
        invalidCredential.code,
        SignInWithGoogleFailureCode.invalidCredential,
      );
    });

    test("Should return unknown code from non FirebaseAuthException ", () {
      final invalidCredential = SignInWithGoogleFailure.fromException(
          FirebaseFunctionsException(message: "test", code: "test"));

      expect(
        invalidCredential.code,
        SignInWithGoogleFailureCode.unknown,
      );
    });
  });
}
