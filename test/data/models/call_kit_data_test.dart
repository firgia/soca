/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Apr 25 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = CallKitData.fromMap(
        const {
          "uuid": "123",
          "type": "incoming_video_call",
          "user_caller": {
            "uid": "123",
            "name": "Test",
            "avatar": "test.jpg",
            "type": "blind",
            "gender": "male",
            "date_of_birth": null,
          },
        },
      );

      const expected = CallKitData(
        uuid: "123",
        type: "incoming_video_call",
        userCaller: UserCaller(
          uid: "123",
          name: "Test",
          avatar: "test.jpg",
          type: "blind",
          gender: "male",
          dateOfBirth: null,
        ),
      );

      expect(actual, expected);
    });
  });
}
