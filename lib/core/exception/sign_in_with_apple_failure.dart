/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 03 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum SignInWithAppleFailureCode {
  /// Device is not supported to sign in with Apple.
  notSupportedDevice,

  /// The supplied auth credential is malformed or has expired
  invalidCredential,

  /// The user canceled the authorization attempt.
  canceled,

  /// The authorization attempt failed.
  failed,

  /// The authorization request received an invalid response.
  invalidResponse,

  /// The authorization request wasn’t handled.
  notHandled,

  /// The authorization request isn’t interactive.
  notInteractive,

  unknown,
}

/// {@template sign_in_with_apple_exception}
/// Thrown during the sign in with Apple process if a failure occurs.
/// https://github.com/aboutyou/dart_packages/blob/master/packages/sign_in_with_apple/sign_in_with_apple_platform_interface/lib/exceptions.dart
/// {@endtemplate}
class SignInWithAppleFailure implements Exception {
  /// {@macro sign_in_with_apple_exception}
  const SignInWithAppleFailure({
    this.code = SignInWithAppleFailureCode.unknown,
    this.message = "An unknown exception occurred.",
  });

  final String message;
  final SignInWithAppleFailureCode code;

  factory SignInWithAppleFailure.fromException(Exception e) {
    if (e is SignInWithAppleNotSupportedException) {
      return const SignInWithAppleFailure(
        code: SignInWithAppleFailureCode.notSupportedDevice,
        message: "Device is not supported to sign in with Apple.",
      );
    } else if (e is SignInWithAppleCredentialsException) {
      return const SignInWithAppleFailure(
        code: SignInWithAppleFailureCode.invalidCredential,
        message: "The supplied auth credential is malformed or has expired",
      );
    } else if (e is SignInWithAppleAuthorizationException) {
      switch (e.code) {
        case AuthorizationErrorCode.failed:
          return const SignInWithAppleFailure(
            code: SignInWithAppleFailureCode.failed,
            message: "The authorization attempt failed",
          );

        case AuthorizationErrorCode.invalidResponse:
          return const SignInWithAppleFailure(
            code: SignInWithAppleFailureCode.invalidResponse,
            message: "The authorization request received an invalid response.",
          );

        case AuthorizationErrorCode.notHandled:
          return const SignInWithAppleFailure(
            code: SignInWithAppleFailureCode.notHandled,
            message: "The authorization request wasn’t handled.",
          );

        case AuthorizationErrorCode.notInteractive:
          return const SignInWithAppleFailure(
            code: SignInWithAppleFailureCode.notInteractive,
            message: "The authorization request isn’t interactive.",
          );

        case AuthorizationErrorCode.canceled:
          return const SignInWithAppleFailure(
            code: SignInWithAppleFailureCode.canceled,
            message: "The user canceled the authorization attempt.",
          );

        default:
          return const SignInWithAppleFailure();
      }
    } else {
      return const SignInWithAppleFailure();
    }
  }
}
