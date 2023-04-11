/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Mon Apr 10 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("CallActionLoading", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        CallActionEnded callAction = const CallActionEnded("123");

        expect(callAction.callID, "123");
      });
    });
  });
}
