/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 01 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';

class _Validator with ValidateName {}

void main() {
  group(".validateName()", () {
    test("Should return null when name is valid", () {
      String name = "Mochamad Firgia";
      String? validator = _Validator().validateName(name);

      expect(validator, isNull);
    });

    test("Should return string when lenght is less than 4 or greater than 25",
        () {
      String name1 = "abc";
      String name2 = "Alexander Purwoto Suryoningrat";

      String? validator1 = _Validator().validateName(name1);
      String? validator2 = _Validator().validateName(name2);

      expect(validator1, isNotNull);
      expect(validator2, isNotNull);
    });

    test("Should return string when non alphabet text is included", () {
      String name = "albert 123 ";
      String? validator = _Validator().validateName(name);

      expect(validator, isNotNull);
    });
  });
}
