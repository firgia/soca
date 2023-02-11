/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = UserActivity.fromMap(
        const {
          "online": true,
          "last_seen": "2023-02-11T14:12:06.182067",
        },
      );

      final expected = UserActivity(
        online: true,
        lastSeen: DateTime.tryParse("2023-02-11T14:12:06.182067"),
      );

      expect(actual, expected);
    });
  });
}
