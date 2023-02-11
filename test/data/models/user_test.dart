/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Feb 11 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = User.fromMap(const {
        "id": "123",
        "avatar": {
          "url": {
            "small": "small.png",
            "medium": "medium.png",
            "large": "large.png",
            "original": "original.png",
          }
        },
        "activity": {
          "online": true,
          "last_seen": "2023-02-11T14:12:06.182067",
        },
        "date_of_birth": "2023-02-11T14:12:06.182067",
        "gender": "male",
        "language": ["id", "en"],
        "name": "Firgia",
        "info": {
          "date_joined": "2023-02-11T14:12:06.182067",
          "list_of_call_years": ["2022", "2023"],
          "total_calls": 12,
          "total_friends": 13,
          "total_visitors": 14,
        },
        "type": "volunteer",
      });

      final expected = User(
        id: "123",
        avatar: const URLImage(
          small: "small.png",
          medium: "medium.png",
          large: "large.png",
          original: "original.png",
        ),
        activity: UserActivity(
          online: true,
          lastSeen: DateTime.tryParse("2023-02-11T14:12:06.182067"),
        ),
        dateOfBirth: DateTime.tryParse("2023-02-11T14:12:06.182067"),
        gender: Gender.male,
        language: const ["id", "en"],
        name: "Firgia",
        info: UserInfo(
          dateJoined: DateTime.tryParse("2023-02-11T14:12:06.182067"),
          listOfCallYears: const ["2022", "2023"],
          totalCalls: 12,
          totalFriends: 13,
          totalVisitors: 14,
        ),
        type: UserType.volunteer,
      );

      expect(actual, expected);
    });
  });
}
