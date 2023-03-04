/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Feb 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = Language.fromMap(
        const {
          "code": "id",
          "name": "Indonesian",
          "nativeName": "Bahasa Indonesia"
        },
      );

      const expected = Language(
        code: "id",
        name: "Indonesian",
        nativeName: "Bahasa Indonesia",
      );

      expect(actual, expected);
    });
  });
}
