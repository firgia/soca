/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("UserError", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const error = UserError(UserFailure(code: UserFailureCode.unknown));

        expect(error.failure, const UserFailure(code: UserFailureCode.unknown));
      });
    });
  });

  group("UserLoaded", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const loaded = UserLoaded(User(id: "123", name: "firgia"));

        expect(loaded.data, const User(id: "123", name: "firgia"));
      });
    });
  });
}
