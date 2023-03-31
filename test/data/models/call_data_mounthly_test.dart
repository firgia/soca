/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = CallDataMounthly.fromMap(
        const {
          "month": "april",
          "total": 12,
        },
      );

      const expected = CallDataMounthly(
        month: "april",
        total: 12,
      );

      expect(actual, expected);
    });
  });
}
