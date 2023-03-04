/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Feb 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("SignUpError", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const error =
            SignUpError(SignUpFailure(code: SignUpFailureCode.unknown));

        expect(error.failure,
            const SignUpFailure(code: SignUpFailureCode.unknown));
      });
    });
  });
}
