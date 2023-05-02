/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Sat Apr 29 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/core/core.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("AssistantCommandEventAdded", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        const AssistantCommandEventAdded event =
            AssistantCommandEventAdded(AssistantCommandType.callVolunteer);

        expect(event.data, AssistantCommandType.callVolunteer);
      });
    });
  });
}
