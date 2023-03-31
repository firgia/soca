/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Fri Mar 31 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = CallStatistic.fromMap(const {
        "total": 12,
        "monthly_statistics": [
          {
            "month": "april",
            "total": 12,
          },
        ],
      });

      const expected = CallStatistic(
        total: 12,
        monthlyStatistics: [
          CallDataMounthly(
            month: "april",
            total: 12,
          ),
        ],
      );

      expect(actual, expected);
    });
  });
}
