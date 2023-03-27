/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Mar 27 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = Call.fromMap(
        const {
          "id": "1234",
          "rtc_channel_id": "456",
          "created_at": "2023-02-11T14:12:06.182067",
          "settings": {
            "enable_flashlight": false,
            "enable_flip": false,
          },
          "users": {
            "blind_id": "11",
            "volunteer_id": "12",
          },
          "state": "waiting",
        },
      );

      final expected = Call(
        id: "1234",
        createdAt: DateTime.tryParse("2023-02-11T14:12:06.182067"),
        rtcChannelID: "456",
        state: CallState.waiting,
        users: const UserCall(
          blindID: "11",
          volunteerID: "12",
        ),
        settings: const CallSetting(
          enableFlashlight: false,
          enableFlip: false,
        ),
      );

      expect(actual, expected);
    });
  });
}
