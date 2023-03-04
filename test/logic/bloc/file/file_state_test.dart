/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 24 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("FilePicked", () {
    File file = File("assets/images/raster/avatar.png");
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        FilePicked filePicked = FilePicked(file);

        expect(filePicked.file.path, file.path);
      });
    });
  });

  group("FileError", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        FileError fileError = const FileError(FileFailure());

        expect(fileError.failure, const FileFailure());
      });
    });
  });
}
