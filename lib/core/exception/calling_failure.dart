/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:cloud_functions/cloud_functions.dart';

enum CallingFailureCode {
  /// Client specified an invalid argument.
  invalidArgument,

  /// Some requested document was not found.
  notFound,

  /// The request does not have valid authentication credentials for
  /// the operation.
  unauthenticated,

  /// The caller does not have permission to execute the specified operation.
  permissionDenied,

  /// Volunteers is not available to receive the call
  unavailable,

  unknown,
}

class CallingFailure implements Exception {
  const CallingFailure({
    this.code = CallingFailureCode.unknown,
    this.message = "An unknown exception occurred.",
  });

  final String message;
  final CallingFailureCode code;

  factory CallingFailure.fromException(Exception e) {
    if (e is FirebaseFunctionsException) {
      switch (e.code) {
        case "invalid-argument":
          return const CallingFailure(
            code: CallingFailureCode.invalidArgument,
            message: "Client specified an invalid argument.",
          );

        case "not-found":
          return const CallingFailure(
            code: CallingFailureCode.notFound,
            message: "Some requested document was not found.",
          );

        case "unauthenticated":
          return const CallingFailure(
            code: CallingFailureCode.unauthenticated,
            message:
                'The request does not have valid authentication credentials '
                'for the operation.',
          );

        case "unavailable":
          return const CallingFailure(
            code: CallingFailureCode.unavailable,
            message: 'Volunteers is not available.',
          );

        case "permission-denied":
          return const CallingFailure(
            code: CallingFailureCode.permissionDenied,
            message:
                'The caller does not have permission to execute the specified '
                'operation.',
          );

        default:
          return const CallingFailure();
      }
    } else {
      return const CallingFailure();
    }
  }
}
