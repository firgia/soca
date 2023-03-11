/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';

enum UserFailureCode {
  /// Client specified an invalid argument.
  invalidArgument,

  /// Some requested document was not found.
  notFound,

  /// The request does not have valid authentication credentials for the operation.
  unauthenticated,

  unknown,
}

class UserFailure implements Exception {
  const UserFailure({
    this.code = UserFailureCode.unknown,
    this.message = "An unknown exception occurred.",
  });

  final String message;
  final UserFailureCode code;

  factory UserFailure.fromException(Exception e) {
    if (e is FirebaseFunctionsException) {
      switch (e.code) {
        case "invalid-argument":
          return const UserFailure(
            code: UserFailureCode.invalidArgument,
            message: "Client specified an invalid argument.",
          );

        case "not-found":
          return const UserFailure(
            code: UserFailureCode.notFound,
            message: "Some requested document was not found.",
          );

        case "unauthenticated":
          return const UserFailure(
            code: UserFailureCode.unauthenticated,
            message:
                "The request does not have valid authentication credentials for the operation.",
          );

        default:
          return const UserFailure();
      }
    } else {
      return const UserFailure();
    }
  }
}
