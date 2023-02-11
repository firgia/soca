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

void main() {
  group(".toGender()", () {
    test("Should return Gender.male when male", () {
      expect(
        "male".toGender(),
        Gender.male,
      );

      expect(
        "Male".toGender(),
        Gender.male,
      );
    });

    test("Should return Gender.female when female", () {
      expect(
        "female".toGender(),
        Gender.female,
      );

      expect(
        "Female".toGender(),
        Gender.female,
      );
    });
  });

  group(".toUserType()", () {
    test("Should return UserType.blind when blind", () {
      expect(
        "blind".toUserType(),
        UserType.blind,
      );

      expect(
        "Blind".toUserType(),
        UserType.blind,
      );
    });

    test("Should return UserType.volunteer when volunteer", () {
      expect(
        "volunteer".toUserType(),
        UserType.volunteer,
      );

      expect(
        "Volunteer".toUserType(),
        UserType.volunteer,
      );
    });
  });
}
