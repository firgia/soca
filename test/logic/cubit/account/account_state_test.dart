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
import 'package:soca/logic/cubit/account/account_cubit.dart';

void main() {
  group("AccountData", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        AccountData accountData = const AccountData(
          email: "contact@firgia.com",
          signInMethod: AuthMethod.apple,
        );

        expect(accountData.email, "contact@firgia.com");
        expect(accountData.signInMethod, AuthMethod.apple);
      });
    });
  });
}
