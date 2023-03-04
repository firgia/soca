/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

enum FileFailureCode {
  unknown,
}

class FileFailure implements Exception {
  const FileFailure({
    this.code = FileFailureCode.unknown,
    this.message = "An unknown exception occurred.",
  });

  final String message;
  final FileFailureCode code;

  factory FileFailure.fromException(Exception e) {
    return const FileFailure();
  }
}
