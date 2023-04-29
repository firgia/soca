/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Apr 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/data/data.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("AssistantCommandCallVolunteerLoaded", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const AssistantCommandCallVolunteerLoaded state =
            AssistantCommandCallVolunteerLoaded(
          User(id: "1234"),
        );

        expect(state.data, const User(id: "1234"));
      });
    });
  });
}
