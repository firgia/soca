/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Wed Mar 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = RTCCredential.fromMap(
        const {
          "token": "1234",
          "privilege_expired_time_seconds": 90,
          "channel_name": "sample-channel",
          "uid": 1,
        },
      );

      const expected = RTCCredential(
        token: "1234",
        privilegeExpiredTimeSeconds: 90,
        channelName: "sample-channel",
        uid: 1,
      );

      expect(actual, expected);
    });
  });
}
