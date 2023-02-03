/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Thu Feb 02 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

enum SignInWithGoogleFailureCode {
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
class SignInWithGoogleFailure implements Exception {
  /// {@macro sign_in_with_google_exception}
  const SignInWithGoogleFailure([
    this.code = SignInWithGoogleFailureCode.unknown,
    this.message = "An unknown exception occurred.",
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory SignInWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case "invalid-credential":
        return const SignInWithGoogleFailure(
          SignInWithGoogleFailureCode.invalidCredential,
          "The supplied auth credential is malformed or has expired",
        );

      case "account-exists-with-different-credential":
        return const SignInWithGoogleFailure(
          SignInWithGoogleFailureCode.accountExistsWithDifferentCredential,
          "Account exists with different credential",
        );

      case "user-disabled":
        return const SignInWithGoogleFailure(
          SignInWithGoogleFailureCode.userDisabled,
          "User account has disabled by admin",
        );

      case "operation-not-allowed":
        return const SignInWithGoogleFailure(
          SignInWithGoogleFailureCode.operationNotAllowed,
          "Operation not allowed, the sign-in provider is disabled in Firebase project",
        );

      case "network-request-failed":
        return const SignInWithGoogleFailure(
          SignInWithGoogleFailureCode.networkRequestFailed,
          "Unstable connection network",
        );

      default:
        return const SignInWithGoogleFailure();
    }
  }

  final String message;
  final SignInWithGoogleFailureCode code;
}
