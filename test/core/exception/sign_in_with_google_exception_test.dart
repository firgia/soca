/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

void main() {
  group("Default Constructor", () {
    test("Should return unknown code as a default", () {
      const exception = SignInWithGoogleException();
      expect(exception.code, SignInWithGoogleExceptionCode.unknown);
    });
  });

  group("From Code", () {
    test("Should return code based on string code", () {
      final invalidCredential =
          SignInWithGoogleException.fromCode("invalid-credential");
      final accountExistsWithDifferentCredential =
          SignInWithGoogleException.fromCode(
              "account-exists-with-different-credential");
      final userDisabled = SignInWithGoogleException.fromCode("user-disabled");
      final operationNotAllowed =
          SignInWithGoogleException.fromCode("operation-not-allowed");
      final networkRequestFailed =
          SignInWithGoogleException.fromCode("network-request-failed");
      final unknown = SignInWithGoogleException.fromCode("abc");

      expect(
        invalidCredential.code,
        SignInWithGoogleExceptionCode.invalidCredential,
      );
      expect(
        accountExistsWithDifferentCredential.code,
        SignInWithGoogleExceptionCode.accountExistsWithDifferentCredential,
      );
      expect(
        userDisabled.code,
        SignInWithGoogleExceptionCode.userDisabled,
      );
      expect(
        operationNotAllowed.code,
        SignInWithGoogleExceptionCode.operationNotAllowed,
      );
      expect(
        networkRequestFailed.code,
        SignInWithGoogleExceptionCode.networkRequestFailed,
      );
      expect(
        unknown.code,
        SignInWithGoogleExceptionCode.unknown,
      );
    });
  });
}
