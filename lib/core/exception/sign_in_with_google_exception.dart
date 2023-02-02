/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

enum SignInWithGoogleExceptionCode {
  /// The supplied auth credential is malformed or has expired
  invalidCredential,

  /// Account exists with different credential
  accountExistsWithDifferentCredential,

  /// User account has disabled by admin
  userDisabled,

  /// Operation not allowed, the sign-in provider is disabled in Firebase project
  operationNotAllowed,

  /// Unstable connection network
  networkRequestFailed,

  unknown,
}

/// {@template sign_in_with_google_exception}
/// Thrown during the sign in with google process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithCredential.html
/// {@endtemplate}
class SignInWithGoogleException implements Exception {
  /// {@macro sign_in_with_google_exception}
  const SignInWithGoogleException([
    this.code = SignInWithGoogleExceptionCode.unknown,
    this.message = "An unknown exception occurred.",
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory SignInWithGoogleException.fromCode(String code) {
    switch (code) {
      case "invalid-credential":
        return const SignInWithGoogleException(
          SignInWithGoogleExceptionCode.invalidCredential,
          "The supplied auth credential is malformed or has expired",
        );

      case "account-exists-with-different-credential":
        return const SignInWithGoogleException(
          SignInWithGoogleExceptionCode.accountExistsWithDifferentCredential,
          "Account exists with different credential",
        );

      case "user-disabled":
        return const SignInWithGoogleException(
          SignInWithGoogleExceptionCode.userDisabled,
          "User account has disabled by admin",
        );

      case "operation-not-allowed":
        return const SignInWithGoogleException(
          SignInWithGoogleExceptionCode.operationNotAllowed,
          "Operation not allowed, the sign-in provider is disabled in Firebase project",
        );

      case "network-request-failed":
        return const SignInWithGoogleException(
          SignInWithGoogleExceptionCode.networkRequestFailed,
          "Unstable connection network",
        );

      default:
        return const SignInWithGoogleException();
    }
  }

  final String message;
  final SignInWithGoogleExceptionCode code;
}
