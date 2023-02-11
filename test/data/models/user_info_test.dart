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
      final actual = UserInfo.fromMap(
        const {
          "date_joined": "2023-02-11T14:12:06.182067",
          "list_of_call_years": ["2022", "2023"],
          "total_calls": 12,
          "total_friends": 13,
          "total_visitors": 14,
        },
      );

      final expected = UserInfo(
        dateJoined: DateTime.tryParse("2023-02-11T14:12:06.182067"),
        listOfCallYears: const ["2022", "2023"],
        totalCalls: 12,
        totalFriends: 13,
        totalVisitors: 14,
      );

      expect(actual, expected);
    });
  });

  group(".localDateJoined", () {
    test("Should convert dateJoined to local date", () {
      final userInfo = UserInfo(
        dateJoined: DateTime.tryParse("2023-02-11T14:12:06.182067"),
        listOfCallYears: const ["2022", "2023"],
        totalCalls: 12,
        totalFriends: 13,
        totalVisitors: 14,
      );

      expect(userInfo.localDateJoined, userInfo.dateJoined?.toLocal());
    });
  });
}
