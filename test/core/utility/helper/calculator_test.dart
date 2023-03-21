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

void main() {
  group(".calculateAge()", () {
    test("Should return age based on current time", () {
      int age = Calculator.calculateAge(DateTime(2000, 03, 20));

      // This method using [DateTime.now()]
      //
      // The Last test is 21 Mar 2023
      // This test may fail when execute in the future
      expect(age, 23);
    });
  });
}
