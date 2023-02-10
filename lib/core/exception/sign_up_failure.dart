/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';

enum SignUpFailureCode {
  /// The request does not have valid authentication credentials for the operation.
  unauthenticated,

  /// Client specified an invalid argument.
  invalidArgument,

  unknown,
}

/// {@template sign_up_exception}
/// Thrown during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpFailure implements Exception {
  /// {@macro sign_up_exception}
  const SignUpFailure({
    this.code = SignUpFailureCode.unknown,
    this.message = "An unknown exception occurred.",
  });

  final String message;
  final SignUpFailureCode code;

  factory SignUpFailure.fromException(Exception e) {
    if (e is FirebaseFunctionsException) {
      switch (e.code) {
        case "unauthenticated":
          return const SignUpFailure(
            code: SignUpFailureCode.unauthenticated,
            message:
                "The request does not have valid authentication credentials for the operation.",
          );

        case "invalid-argument":
          return const SignUpFailure(
            code: SignUpFailureCode.invalidArgument,
            message: "Client specified an invalid argument.",
          );

        default:
          return const SignUpFailure();
      }
    } else {
      return const SignUpFailure();
    }
  }
}
