/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sun Mar 12 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';

void main() {
  group(".fromMap()", () {
    test("Should convert map value to fields", () {
      final actual = UserDevice.fromMap(
        const {
          "id": "54321",
          "player_id": "12345",
          "language": "id",
        },
      );

      const expected = UserDevice(
        id: "54321",
        playerID: "12345",
        language: "id",
      );

      expect(actual, expected);
    });
  });
}
