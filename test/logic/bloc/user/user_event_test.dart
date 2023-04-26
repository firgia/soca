/*
 * Author     : Mochamad Firgia
 * Website    : https://www.firgia.com
 * Repository : https://github.com/firgia/soca
 * 
 * Created on Tue Mar 21 2023
 * Copyright (c) 2023 Mochamad Firgia
 */

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:soca/logic/logic.dart';

void main() {
  group("UserGet", () {
    group("()", () {
      test("Should fill up the fields based on the constructor parameter", () {
        final completer = Completer();
        final event1 = UserFetched(uid: "1332", completer: completer);

        expect(event1.uid, "1332");
        expect(event1.completer, completer);

        const event2 = UserFetched();
        expect(event2.uid, null);
        expect(event2.completer, null);
      });
    });
  });
}
